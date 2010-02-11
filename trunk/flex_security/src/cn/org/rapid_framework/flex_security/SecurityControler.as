package cn.org.rapid_framework.flex_security
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.utils.DescribeTypeCache;
	
	//
	// Security filters UI components based on metadata with in UIComponenets
	//
	public class SecurityControler {
		
		public static var defaultControlBy : String = 'visible';
		
		[Bindable] private static var _permissions:ArrayCollection;
		
		/**
		 * start security control before the UIComponents are added with permission strings
		 */
		public static function start(permissions:ArrayCollection = null,default_control_by : String = "visible"):void {
			setPermissions(permissions);
			defaultControlBy = default_control_by;
			
			Application.application.systemManager.addEventListener(Event.ADDED_TO_STAGE, processComponenet, true);
		}
		
		/**
		 * stop security control
		 */
		public static function stop():void {
			Application.application.systemManager.removeEventListener(Event.ADDED_TO_STAGE, processComponenet);
		}
		
		private static function setPermissions(permissions:ArrayCollection)
		{
			if(permissions == null) {
				_permissions = new ArrayCollection();
			} else {
				_permissions = permissions;
			}
			_permissions.sort = new Sort();
			_permissions.refresh();
			_permissions.addEventListener(CollectionEvent.COLLECTION_CHANGE, updateDisplay);
		}
				
		/**
		 * Overwrites perms with ArrayCollection
		 */
		public static function updatePerms(perms:ArrayCollection):void {
			setPermissions(perms);
			//update display
			updateDisplay(null);
		}

		/**
		 * Adds permissions to the security
		 */
		public static function addPerm(permName:String):void {
			_permissions.addItem(permName);
		}

		/**
		 * Removes permission from security
		 */
		public static function removePerm(permName:String):void {
			while(_permissions.contains(permName))
				_permissions.removeItemAt(_permissions.getItemIndex(permName));
		}
		
		public static function addSecurityAction(comp:UIComponent,permission:String = null,controlBy:String = null) {
			var securityAction : SecurityAction = new SecurityAction();
			securityAction.comp = comp;
			securityAction.componentId = comp.id;
			securityAction.permission = permission == null ? comp.id : permission;
			securityAction.controlBy = controlBy == null ? defaultControlBy : controlBy;
			
			SecurityActionCache.instance.addAction(securityAction);
			doAction(securityAction);
		}
		
		//updates display on changes to the roles
		private static function updateDisplay(event:Event):void {
			for each(var securityAction:SecurityAction in SecurityActionCache.instance.getAllActions()) {
				doAction(securityAction);
			}
		}
		
		//event for processing when component is added
		private static function processComponenet(event:Event):void {
			process(event.target);
		}
		
		//process ui object
		private static function process(obj:Object):void {
			if(obj is UIComponent) {
				var comp:UIComponent = obj as UIComponent;
				//check for wating action
				if(comp.id != null && SecurityActionCache.instance.isDelayLoadComp(comp.id)) { 
					for each(var delayedSecurityAction:SecurityAction in SecurityActionCache.instance.getDelayLoadActions(comp)) {
						delayedSecurityAction.comp = comp;
						doAction(delayedSecurityAction);
						SecurityActionCache.instance.addAction(delayedSecurityAction);							
					}
				} 
				
				//process by annotation
				var typeInfo:XML = DescribeTypeCache.describeType(obj).typeDescription;
				var md:XMLList = typeInfo.metadata.(@name == SecurityConstants.PROTECTED_ANNOTATION_NAME);				
				for each (var metadata:XML in md) {
					var securityAction:SecurityAction = SecurityAction.createActionFromAnnotation(metadata,defaultControlBy);
					processBySecurityAction(comp,securityAction);
				}
				
				//precess by styleName
				var securityAction:SecurityAction = SecurityAction.createActionFromStyleName(comp,defaultControlBy);
				if(securityAction != null) {
					SecurityActionCache.instance.addAction(securityAction);
					doAction(securityAction);
				}
				
				//process by ISecurityMetadata
				if(comp is ISecurityMetadata) {
					var securityMetadaa : ISecurityMetadata = comp as ISecurityMetadata;
					for each (var item : Object in securityMetadaa.getSecurityActions()) {
						var securityAction:SecurityAction = SecurityAction.createActionFromInterface(item,defaultControlBy);
						if(securityAction != null) {
							SecurityActionCache.instance.addAction(securityAction);
							doAction(securityAction);
						}
					}
				}
			//going to have to match on id and parentDocument
			}
		}
		
		//TODO rename to findChildToProcess
		private static function processBySecurityAction(comp:UIComponent,securityAction:SecurityAction):void 
		{
			if(securityAction.componentId == null || 
					securityAction.componentId == "" || securityAction.componentId == SecurityConstants.PARENT_STRING) { //process protections for parent
				securityAction.comp = comp;
				doAction(securityAction);
				SecurityActionCache.instance.addAction(securityAction);
			} else {
				if(comp.getChildByName(securityAction.componentId) == null) { // child comp has not been created yet 										
					securityAction.parentComp = comp;	
					SecurityActionCache.instance.addDelayLoadAction(securityAction);	
				} else { //process child component
					securityAction.comp = comp.getChildByName(securityAction.componentId) as UIComponent;
					doAction(securityAction);
					SecurityActionCache.instance.addAction(securityAction);
				}
			}			
		}
				
		//process action
		private static function doAction(securityAction:SecurityAction):void {
			var controlBy : String = securityAction.controlBy;
			if(isPermitted(securityAction.permission)) {
				trace('permitted, controlBy:'+controlBy+" comp.id:"+securityAction.comp.id + " comp:"+securityAction.comp);
				if( controlBy == SecurityConstants.CONTROY_BY_ENABLE ||
					controlBy == SecurityConstants.CONTROY_BY_VISABLE ||
					controlBy == SecurityConstants.CONTROY_BY_INCLUDE_IN_LAYOUT) 
				{
					securityAction.comp[controlBy] = true;
				}
				else if (controlBy == SecurityConstants.CONTROY_BY_REMOVE) 
				{
					if(securityAction.parentComp != null && securityAction.parentComp is UIComponent && !securityAction.parentComp.contains(securityAction.comp)) {
						securityAction.parentComp.addChildAt(securityAction.comp, securityAction.childPosition);
					}
				}
				else 
				{
					throw new Error("unknow controlBy:"+controlBy+" on componentId:"+securityAction.componentId);
				}
			} else {
				trace('not permitted, controlBy:'+controlBy+" comp.id:"+securityAction.comp.id + " comp:"+securityAction.comp);
				if( controlBy == SecurityConstants.CONTROY_BY_ENABLE ||
					controlBy == SecurityConstants.CONTROY_BY_VISABLE ||
					controlBy == SecurityConstants.CONTROY_BY_INCLUDE_IN_LAYOUT ) 
				{
					securityAction.comp[controlBy] = false;
				}
				else if (controlBy == SecurityConstants.CONTROY_BY_REMOVE) 
				{
					//trace('prepare remove from parent:'+securityAction.comp.parent+" comp.id:"+securityAction.comp.id+" childPosition:"+securityAction.childPosition);
					//test child is removed
					if(securityAction.comp.parent != null) {
						//trace('real remove from parent:'+securityAction.comp.parent+" comp.id:"+securityAction.comp.id+" childPosition:"+securityAction.childPosition);
						securityAction.parentComp = securityAction.comp.parent as UIComponent;
						securityAction.childPosition = (securityAction.comp.parent as UIComponent).getChildIndex(securityAction.comp);
						(securityAction.comp.parent as UIComponent).removeChild(securityAction.comp);
					}
				}
				else 
				{
					throw new Error("unknow controlBy:"+controlBy+" on componentId:"+securityAction.componentId);
				}
			}
		}

		//check for permissions
		public static function isPermitted(allowedPerms:String):Boolean {
			if(allowedPerms == null) return false;
			var paramArray : Array = allowedPerms.split(',');
			for each(var perm:String in paramArray) {
				if(_permissions.contains(perm)) {
					return true;
				}
			}
			return false;
		}
		
	}
}
