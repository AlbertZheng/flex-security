package cn.org.rapid_framework.flex_security
{
	import mx.controls.Button;
	import mx.core.UIComponent;
	
	import org.flexunit.asserts.*;
	
	public class SecurityActionTest
	{
		var DEFAULT_CONTROL_BY = 'visible';
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
			verifySecurityAction(action,"user_new",DEFAULT_CONTROL_BY,button);
			
			button.styleName = "security";
			var action : SecurityAction = SecurityAction.createActionFromStyleName(button,SecurityControler.defaultControlBy);
			verifySecurityAction(action,"user_new",DEFAULT_CONTROL_BY,button);
			
			button.styleName = "security(user_new_by_arg)";
			var action : SecurityAction = SecurityAction.createActionFromStyleName(button,SecurityControler.defaultControlBy);
			verifySecurityAction(action,"user_new_by_arg",DEFAULT_CONTROL_BY,button);
			
			button.styleName = "security(null)";
			var action : SecurityAction = SecurityAction.createActionFromStyleName(button,SecurityControler.defaultControlBy);
			verifySecurityAction(action,"user_new",DEFAULT_CONTROL_BY,button);
			
			button.styleName = "security(null,enabled)";
			var action : SecurityAction = SecurityAction.createActionFromStyleName(button,SecurityControler.defaultControlBy);
			verifySecurityAction(action,"user_new",'enabled',button);

			button.styleName = "security(null,null)";
			var action : SecurityAction = SecurityAction.createActionFromStyleName(button,SecurityControler.defaultControlBy);
			verifySecurityAction(action,"user_new",DEFAULT_CONTROL_BY,button);

			button.styleName = "security(,enabled)";
			var action : SecurityAction = SecurityAction.createActionFromStyleName(button,SecurityControler.defaultControlBy);
			verifySecurityAction(action,"user_new",'enabled',button);
									
			button.styleName = "security(user_new_by_arg,enabled)";
			var action : SecurityAction = SecurityAction.createActionFromStyleName(button,SecurityControler.defaultControlBy);
			verifySecurityAction(action,"user_new_by_arg",'enabled',button);
			
			button.styleName = "abc123 diy   security(user_update)   ";
			var action : SecurityAction = SecurityAction.createActionFromStyleName(button,SecurityControler.defaultControlBy);
			verifySecurityAction(action,"user_update",DEFAULT_CONTROL_BY,button);
		}

		[Test]
		public function createActionFromStyleNameWithErrorInput() : void {
			
			button.styleName = "security errorstring";
			var action : SecurityAction = SecurityAction.createActionFromStyleName(button,SecurityControler.defaultControlBy);
			verifySecurityAction(action,"user_new",DEFAULT_CONTROL_BY,button);
			
			
		}
		[Test(expects="Error")]
		public function createActionFromStyleNameWithErrorControlBy() : void {
			button.styleName = "security(user_new_by_input,error_controlBy)";
			var action : SecurityAction = SecurityAction.createActionFromStyleName(button,SecurityControler.defaultControlBy);
		}
		
		[Test]
		public function createActionFromInterface() : void {
			
			var action : SecurityAction = SecurityAction.createActionFromInterface(new SecurityAction(button),SecurityControler.defaultControlBy);
			verifySecurityAction(action,"user_new",DEFAULT_CONTROL_BY,button);
			
			var action : SecurityAction = SecurityAction.createActionFromInterface([button],SecurityControler.defaultControlBy);
			verifySecurityAction(action,"user_new",DEFAULT_CONTROL_BY,button);
			
			var action : SecurityAction = SecurityAction.createActionFromInterface([button,'user_new_by_arg'],SecurityControler.defaultControlBy);
			verifySecurityAction(action,"user_new_by_arg",DEFAULT_CONTROL_BY,button);
			
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