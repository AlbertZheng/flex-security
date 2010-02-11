package cn.org.rapid_framework.flex_security
{
	import mx.containers.HBox;
	import mx.controls.Button;
	
	import org.flexunit.asserts.*;
	
	public class SecurityControlerTest
	{
		var box :HBox = new HBox();
		var button : Button = new Button();
		public function SecurityControlerTest()
		{
			//TODO: implement function
		}
		[Before]
		public function setUp() : void {
			//SecurityControler.addPerm('error_xxxx292828_xowi');
			
			SecurityControler.removeAllPerms();
			box.addChild(button);
		}
		
		[Test]
		public function testRemove() : void {
			assertTrue(box.contains(button));
			var action : SecurityAction = new SecurityAction(button,"user_new",SecurityConstants.CONTROY_BY_REMOVE);
			SecurityControler.doAction(action);
			assertFalse(box.contains(button));
			
			SecurityControler.addPerm("user_new");
			SecurityControler.doAction(action);
			assertTrue(box.contains(button));
		}
		
		[Test]
		public function testEnabled() : void {
			assertTrue(button.enabled);
			var action : SecurityAction = new SecurityAction(button,"user_new",SecurityConstants.CONTROY_BY_ENABLE);
			SecurityControler.doAction(action);
			assertFalse(button.enabled);
			
			SecurityControler.addPerm("user_new");
			SecurityControler.doAction(action);
			assertTrue(button.enabled);		
		}
		
		[Test]
		public function testVisible() : void {
			assertTrue(button.visible);
			var action : SecurityAction = new SecurityAction(button,"user_new",SecurityConstants.CONTROY_BY_VISABLE);
			SecurityControler.doAction(action);
			assertFalse(button.visible);
			
			SecurityControler.addPerm("user_new");
			SecurityControler.doAction(action);
			assertTrue(button.visible);		
		}
		
		[Test]
		public function testIncludeInLayout() : void {
			assertTrue(button.includeInLayout);
			var action : SecurityAction = new SecurityAction(button,"user_new",SecurityConstants.CONTROY_BY_INCLUDE_IN_LAYOUT);
			SecurityControler.doAction(action);
			assertFalse(button.includeInLayout);
			
			SecurityControler.addPerm("user_new");
			SecurityControler.doAction(action);
			assertTrue(button.includeInLayout);		
		}

		[Test]
		public function addPerm() : void {
			fail("addPerm() is error, must SecurityControler.start() before addPerm()");
		}
				
		[Test]
		public function isPermented() : void {
			SecurityControler.addPerm("super");
			
			assertFalse(SecurityControler.isPermitted(null));
			assertFalse(SecurityControler.isPermitted('admin'));
			assertFalse(SecurityControler.isPermitted('admin,user'));
			
			assertTrue(SecurityControler.isPermitted('super'));
			assertTrue(SecurityControler.isPermitted('super,admin'));
			
			SecurityControler.removePerm("super");
		}
		
		[Test]
		public function removePerm() : void {
			SecurityControler.addPerm("super");
			
			assertTrue(SecurityControler.isPermitted('super'));
			
			SecurityControler.removePerm("super");
			assertFalse(SecurityControler.isPermitted('super'));
		}
		
		[Test]
		public function removeAllPerms() : void {
			SecurityControler.addPerm("super");
			
			assertTrue(SecurityControler.isPermitted('super'));
			
			SecurityControler.removeAllPerms();
			assertFalse(SecurityControler.isPermitted('super'));
		}
		
		[Test]
		public function addSecurityAction() : void {
			SecurityControler.addPerm("super");
			
			SecurityControler.addSecurityAction(button,'admin','enabled');
			assertFalse(button.enabled);
			
			SecurityControler.addSecurityAction(button,'super','enabled');
			assertTrue(button.enabled);
			
		}
	}
}