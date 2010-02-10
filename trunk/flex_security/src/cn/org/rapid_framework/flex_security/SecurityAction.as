package cn.org.rapid_framework.flex_security
{
	import mx.core.UIComponent;
	
	public class SecurityAction
	{
		public function SecurityAction()
		{
		}
		
		public var comp:UIComponent;
		public var parentComp:UIComponent;
		public var childPosition:int;
		public var permissions:String;
		
		public var controlBy : String; //visible,enabled,includeInLayout,remove
		
		public var componentId:String;

	}
}