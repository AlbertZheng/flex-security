package cn.org.rapid_framework.flex_security
{
	import mx.core.UIComponent;
	
	public class SecurityAction
	{
		public function SecurityAction(comp:UIComponent = null , permission : String = null,controlBy : String = null)
		{
			this.comp = comp;
			this.permission = permission;
			this.controlBy = controlBy;
		}
		
		var childPosition:int;
		var parentComp:UIComponent;
		var componentId:String;
		
		public var comp:UIComponent;
		public var permission:String;
		public var controlBy : String; //visible,enabled,includeInLayout,remove


		public static function createActionFromInterface(metadata:Object,defaultControlBy : String) : SecurityAction {
			if(metadata == null) return null;
			
			if(metadata is Array) {
				var array : Array = metadata as Array;
				var result:SecurityAction = new SecurityAction();
				result.comp = array[0]; 
				result.permission = array.length > 1 ? array[1] : result.comp.id; 
				result.controlBy = array.length > 2 ? array[2] : defaultControlBy; 
				//result.componentId = SecurityConstants.PARENT_STRING;
				return result;
			}else if(metadata is SecurityAction) {
				var action : SecurityAction = metadata as SecurityAction;
				var result:SecurityAction = new SecurityAction();
				result.comp = action.comp;
				result.permission = action.permission == null ? action.comp.id : action.permission;
				result.controlBy = action.controlBy == null ? defaultControlBy : action.controlBy;	
				//result.componentId = SecurityConstants.PARENT_STRING;
				return result;		
			}else {
				throw new Error('unknow security metadata:'+metadata);
			}
		}
		
		public static function createActionFromAnnotation(protectedMetadata:XML,defaultControlBy : String):SecurityAction {
			var securityAction:SecurityAction = new SecurityAction();
			securityAction.permission = protectedMetadata..arg.(@key == "permission").@value;
			securityAction.componentId = protectedMetadata..arg.(@key == "id").@value;
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
		
		static var SECURITY_PATTERN : RegExp = /security\((\w*),?(\w*)\)?/;
		public static function createActionFromStyleName(comp:UIComponent,defaultControlBy : String):SecurityAction {
			//trace('prepare generate action from styleName:'+styleName+' on comp:'+comp);
			var styleName : String = comp.styleName as String
			if(styleName == null || styleName.indexOf("security") == -1)
				return null;
			
			var securityAction:SecurityAction = new SecurityAction();
			securityAction.comp = comp;
			//securityAction.componentId = SecurityConstants.PARENT_STRING;
			
			var args : Array = SECURITY_PATTERN.exec(styleName);
			securityAction.permission = args != null && args.length > 1 ? args[1] : comp.id ;
			securityAction.controlBy = args != null && args.length > 2 ? args[2] : defaultControlBy;
			if(securityAction.permission == null || securityAction.permission == '') {
				securityAction.permission = comp.id;
			}
			if(securityAction.controlBy == null || securityAction.controlBy == '') {
				securityAction.controlBy = defaultControlBy;
			}
			//trace('createActionFromStyleName() return security action:'+securityAction);
			return securityAction;
		}
		
	}
}