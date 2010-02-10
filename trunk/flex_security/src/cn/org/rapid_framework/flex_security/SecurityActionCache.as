package cn.org.rapid_framework.flex_security
{
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	public class SecurityActionCache
	{
		public function SecurityActionCache()
		{
			if(instance != null) {
				throw new Error("SecurityActionCache is singleton");
			}
		}

		public static var instance:SecurityActionCache = new SecurityActionCache();	

		private var delayLoadActions:ArrayCollection = new ArrayCollection();
		private var delayLoadIds:ArrayCollection = new ArrayCollection();
		private var actions:ArrayCollection = new ArrayCollection();
		
		/**
		 * Adds complete action to the cache
		 */ 
		public function addAction(action:SecurityAction):void {
			actions.addItem(action);
			
			//remove from delay cache
			if(this.delayLoadActions.contains(action))
				this.delayLoadActions.removeItemAt(this.delayLoadActions.getItemIndex(action));
		}	

		/**
		 * Returns all complete actions
		 */
		public function getAllActions():ArrayCollection {
			return this.actions;
		}

		/**
		 * Adds and action for component that has not beed added yet
		 */
		public function addDelayLoadAction(action:SecurityAction):void {
			delayLoadActions.addItem(action);
			delayLoadIds.addItem(action.componentId);
		}		
		
		/**
		 * Checks for id of component so that caller can check for it before calling method to load
		 */
		public function getDelayLoadHasId(id:String):Boolean {
			return this.delayLoadIds.contains(id);			
		}
		
		/**
		 * returns all the delayed actions for a component added
		 */
		public function getDelayLoadAction(comp:UIComponent):ArrayCollection {
			var list:ArrayCollection = new ArrayCollection();
			for each(var da:SecurityAction in delayLoadActions) {
				if(da.componentId == comp.id) {
					if(hasParent(comp,da.parentComp))
						list.addItem(da);
				}						
			}
			return list;
		}
		
		//check for action parent in tree
		private static function hasParent(comp:UIComponent, parent:UIComponent):Boolean {
			if(comp.parent != null && comp.parent is UIComponent) {
				if(comp.parent == parent) {
					return true;
				} else {
					return hasParent(comp.parent as UIComponent, parent);
				}
			}
			return false;				
		}
	}
}
