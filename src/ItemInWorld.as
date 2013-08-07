package  
{	
	public class ItemInWorld
	{
		public var x:int;
		public var y:int;
		public var item:Item;
		
		public function ItemInWorld(x:int, y:int, item:Item)
		{
			this.x = x;
			this.y = y;
			this.item = item;
		}
	}
}