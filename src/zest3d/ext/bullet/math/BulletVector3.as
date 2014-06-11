package zest3d.ext.bullet.math 
{
	import AWPC_Run.CModule;
	import AWPC_Run.vector3;
	import io.plugin.math.algebra.AVector;
	import zest3d.ext.bullet.BulletBase;
	
	/**
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletVector3 extends BulletBase 
	{
		
		private var _v3d : AVector = new AVector();
		
		public function BulletVector3( ptr:uint = 0) 
		{
			if ( ptr > 0 )
			{
				pointer = ptr;
			}
			else
			{
				pointer = vector3();
				this.x = 0;
				this.y = 0;
				this.z = 0;
			}
		}
		
		public function get x() : Number {
			return CModule.readFloat(pointer + 0);
		}
		
		public function set x(v : Number) : void {
			CModule.writeFloat(pointer + 0, v);
		}
		
		public function get y() : Number {
			return CModule.readFloat(pointer + 4);
		}
		
		public function set y(v : Number) : void {
			CModule.writeFloat(pointer + 4, v);
		}
		
		public function get z() : Number {
			return CModule.readFloat(pointer + 8);
		}
		
		public function set z(v : Number) : void {
			CModule.writeFloat(pointer + 8, v);
		}
		
		public function get v3d() : AVector {
			_v3d.set( x, y, z );
			return _v3d;
		}
		
		public function set v3d(v : AVector) : void {
			x = v.x;
			y = v.y;
			z = v.z;
		}
		
		public function get sv3d() : AVector {
			_v3d.set(x, y, z);
			_v3d.scale(_scaling);
			return _v3d;
		}
		
		public function set sv3d(v : AVector) : void {
			x = v.x / _scaling;
			y = v.y / _scaling;
			z = v.z / _scaling;
		}
		
	}

}