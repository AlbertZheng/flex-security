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
		
		var _childPosition:int;
		
		public var parentComp:UIComponent;
		public var comp:UIComponent;
		
		public var componentId:String;
		public var permission:String;
		public var controlBy : String; //visible,enabled,includeInLayout,remove


		public static function createActionFromInterface(action:SecurityAction,defaultControlBy : String) : SecurityAction {
			var result:SecurityAction = new SecurityAction();
			result.componentId = action.comp.id;
			result.permission = action.permission == null ? result.componentId : action.permission;
			result.controlBy = action.controlBy == null ? defaultControlBy : action.controlBy;	
			return result;		
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
			securityAction.componentId = SecurityConstants.PARENT_STRING;
			
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