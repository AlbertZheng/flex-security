package cn.org.rapid_framework.flex_security
{
	import mx.controls.Button;
	import mx.core.UIComponent;
	
	import org.flexunit.asserts.*;
	
	public class SecurityActionTest
	{
		public function SecurityActionTest()
		{
			//TODO: implement function
		}
		var button : Button = new Button();
		[Before]
		public function setUp() {
			button.id = "user_new";
		}
			
		[Test]
		public function createActionFromStyleName() : void {
			
			button.styleName = "security()";
			var action : SecurityAction = SecurityAction.createActionFromStyleName(button,SecurityControler.defaultControlBy);
			verifySecurityAction(action,"user_new",'visible',button);
			
			button.styleName = "security";
			var action : SecurityAction = SecurityAction.createActionFromStyleName(button,SecurityControler.defaultControlBy);
			verifySecurityAction(action,"user_new",'visible',button);
			
			button.styleName = "security(user_new_by_arg)";
			var action : SecurityAction = SecurityAction.createActionFromStyleName(button,SecurityControler.defaultControlBy);
			verifySecurityAction(action,"user_new_by_arg",'visible',button);
			
			button.styleName = "security(user_new_by_arg,enabled)";
			var action : SecurityAction = SecurityAction.createActionFromStyleName(button,SecurityControler.defaultControlBy);
			verifySecurityAction(action,"user_new_by_arg",'enabled',button);
		}

		[Test]
		public function createActionFromStyleNameWithErrorInput() : void {
			
			button.styleName = "security errorstring";
			var action : SecurityAction = SecurityAction.createActionFromStyleName(button,SecurityControler.defaultControlBy);
			verifySecurityAction(action,"user_new",'visible',button);
			
			
		}
		[Test(expects="Error")]
		public function createActionFromStyleNameWithErrorControlBy() : void {
			button.styleName = "security(user_new_by_input,error_controlBy)";
			var action : SecurityAction = SecurityAction.createActionFromStyleName(button,SecurityControler.defaultControlBy);
		}
		
		[Test]
		public function createActionFromInterface() : void {
			
			var action : SecurityAction = SecurityAction.createActionFromInterface(new SecurityAction(button),SecurityControler.defaultControlBy);
			verifySecurityAction(action,"user_new",'visible',button);
			
			var action : SecurityAction = SecurityAction.createActionFromInterface([button],SecurityControler.defaultControlBy);
			verifySecurityAction(action,"user_new",'visible',button);
			
			var action : SecurityAction = SecurityAction.createActionFromInterface([button,'user_new_by_arg'],SecurityControler.defaultControlBy);
			verifySecurityAction(action,"user_new_by_arg",'visible',button);
			
			var action : SecurityAction = SecurityAction.createActionFromInterface([button,'user_new_by_arg','enabled'],SecurityControler.defaultControlBy);
			verifySecurityAction(action,"user_new_by_arg",'enabled',button);
		}

		[Test(expects="Error")]
		public function createActionFromInterfaceWithErrorControlBy1() : void {
			var action : SecurityAction = SecurityAction.createActionFromInterface([button,'user_new_by_arg','error_controlBy'],SecurityControler.defaultControlBy);
		}
		
		[Test(expects="Error")]
		public function createActionFromInterfaceWithErrorControlBy2() : void {
			var action : SecurityAction = SecurityAction.createActionFromInterface(new SecurityAction(button,"user_new_by_arg","error_control_by"),SecurityControler.defaultControlBy);
		}
						
		public function verifySecurityAction(action:SecurityAction,permission:String,controlBy:String,comp:UIComponent) {
			assertEquals(permission,action.permission);
			assertEquals(controlBy,action.controlBy);
			assertEquals(comp,action.comp);
		}
	}
}