package zest3d.ext.bullet.collision.dispatch 
{
	import io.plugin.math.algebra.AVector;
	import zest3d.ext.bullet.BulletBase;
	
	/**
	 * TODO make these APoint objects?
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletRay extends BulletBase 
	{
		public var rayFrom:AVector;
		public var rayTo:AVector;
		
		public function BulletRay(from:AVector, to:AVector, ptr:uint = 0) 
		{
			rayFrom = from;
			rayTo = to;
			pointer = ptr;
		}
		
	}

}