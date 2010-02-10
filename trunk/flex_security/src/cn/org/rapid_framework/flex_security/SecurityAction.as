package cn.org.rapid_framework.flex_security
{
	import mx.core.UIComponent;
	
	public class SecurityAction
	{
		public function SecurityAction()
		{
		}
		static public const INIT_CHILD_POSITION : int = -9999;
		
		var _isRemoved : Boolean = false;
		var _childPosition:int = INIT_CHILD_POSITION;
		
		public var comp:UIComponent;
		public var parentComp:UIComponent;
		
		public var permission:String;
		public var controlBy : String; //visible,enabled,includeInLayout,remove
		public var componentId:String;

	}
}