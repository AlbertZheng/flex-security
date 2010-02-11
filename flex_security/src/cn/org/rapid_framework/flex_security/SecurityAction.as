package cn.org.rapid_framework.flex_security
{
	import mx.core.UIComponent;
	
	public class SecurityAction
	{
		public function SecurityAction()
		{
		}
		
		var _isRemoved : Boolean = false;
		var _childPosition:int;
		
		public var comp:UIComponent;
		public var parentComp:UIComponent;
		
		public var permission:String;
		public var controlBy : String; //visible,enabled,includeInLayout,remove
		public var componentId:String;


		public static function createActionFromInterface(item:Object,defaultControlBy : String) : SecurityAction {
			var securityAction:SecurityAction = new SecurityAction();
			securityAction.componentId = item.id;
			securityAction.permission = item.permission == null ? item.id : item.permission;
			securityAction.controlBy = item.controlBy == null ? defaultControlBy : item.controlBy;	
			return securityAction;		
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

		public static function createActionFromStyleName(comp:UIComponent,styleName:String,defaultControlBy : String):SecurityAction {
			//trace('prepare generate action from styleName:'+styleName+' on comp:'+comp);
			if(styleName == null || styleName.indexOf("security:") == -1)
				return null;
			var securityAction:SecurityAction = new SecurityAction();
			securityAction.permission = styleName.split("security:")[1];
			securityAction.controlBy = defaultControlBy;
			securityAction.comp = comp;
			securityAction.componentId = SecurityConstants.PARENT_STRING;
			if(securityAction.permission == null || securityAction.permission == '') {
				securityAction.permission = comp.id;
			}
			//trace('createActionFromStyleName() return security action:'+securityAction);
			return securityAction;
		}
		
	}
}