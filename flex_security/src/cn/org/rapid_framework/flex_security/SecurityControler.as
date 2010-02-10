package cn.org.rapid_framework.flex_security
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.utils.DescribeTypeCache;
	
	//
	// Security filters UI components based on metadata with in UIComponenets
	//
	public class SecurityControler {
		
		public static var defaultControlBy : String = null;
		
		[Bindable] private static var _permissions:ArrayCollection;
		
		/**
		 * start security control before the UIComponents are added with permission strings
		 */
		public static function start(permissions:ArrayCollection = null,default_control_by : String = "visible"):void {
			setPermissions(permissions);
			defaultControlBy = default_control_by;
			
			//add chmip system add handler	
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
				var typeInfo:XML = DescribeTypeCache.describeType(obj).typeDescription;
				var md:XMLList = typeInfo.metadata.(@name == SecurityConstants.PROTECTED_ANNOTATION_NAME);
	
				//check for wating action
				if(comp.id != null && SecurityActionCache.instance.getDelayLoadHasId(comp.id)) { 
					for each(var delayedSecurityAction:SecurityAction in SecurityActionCache.instance.getDelayLoadAction(comp)) {
						delayedSecurityAction.comp = comp;
						doAction(delayedSecurityAction);
						SecurityActionCache.instance.addAction(delayedSecurityAction);							
					}
				} 
				
				for each (var metadata:XML in md) {
					var securityAction:SecurityAction = getAction(metadata);
					
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
				
			//going to have to match on id and parentDocument
			}
		}
		
		//create action from meta data
		private static function getAction(protectedMetadata:XML):SecurityAction {
			var securityAction:SecurityAction = new SecurityAction();
			securityAction.permission = protectedMetadata..arg.(@key == "permission").@value;
			securityAction.componentId = protectedMetadata..arg.(@key == "componentId").@value;
			securityAction.controlBy = protectedMetadata..arg.(@key == "controlBy").@value;
			
			//default value
			if(securityAction.controlBy == null || securityAction.controlBy == '') {
				securityAction.controlBy = defaultControlBy;
			}
			if(securityAction.permission == null || securityAction.permission == '') {
				securityAction.permission = securityAction.componentId;
			}
			return securityAction;
		}
		
		//process action
		private static function doAction(securityAction:SecurityAction):void {
			var controlBy : String = securityAction.controlBy;
			if(isPermPresent(securityAction.permission)) {
				if( controlBy == SecurityConstants.CONTROY_BY_ENABLE ||
					controlBy == SecurityConstants.CONTROY_BY_VISABLE ||
					controlBy == SecurityConstants.CONTROY_INCLUDE_IN_LAYOUT) 
				{
					securityAction.comp[controlBy] = true;
				}
				else if (controlBy == SecurityConstants.CONTROY_REMOVE_CHILD) 
				{
					if(securityAction.parentComp != null && securityAction.parentComp is UIComponent)
						securityAction.parentComp.addChildAt(securityAction.comp, securityAction.childPosition);
				}
				else 
				{
					throw new Error("unknow controlBy:"+controlBy+" on componentId:"+securityAction.componentId);
				}
			} else {
				if( controlBy == SecurityConstants.CONTROY_BY_ENABLE ||
					controlBy == SecurityConstants.CONTROY_BY_VISABLE ||
					controlBy == SecurityConstants.CONTROY_INCLUDE_IN_LAYOUT ) 
				{
					securityAction.comp[controlBy] = false;
				}
				else if (controlBy == SecurityConstants.CONTROY_REMOVE_CHILD) 
				{
					securityAction.parentComp = securityAction.comp.parent as UIComponent;
					securityAction.childPosition = (securityAction.comp.parent as UIComponent).getChildIndex(securityAction.comp);
					(securityAction.comp.parent as UIComponent).removeChild(securityAction.comp);
				}
				else 
				{
					throw new Error("unknow controlBy:"+controlBy+" on componentId:"+securityAction.componentId);
				}
			}
		}

		//check for permissions
		private static function isPermPresent(allowedPerms:String):Boolean {
			if(allowedPerms != null) {
				for each(var perm:String in _permissions) {
					if(perm != null && perm.length > 0 && allowedPerms.indexOf(perm) >= 0)
						return true;
				}
			}
			return false;
		}
	}
}