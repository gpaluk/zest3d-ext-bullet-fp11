package zest3d.ext.bullet.groups 
{
	/**
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletCollisionFilterGroup
	{
		public static const DEFAULT : int = 1;
		public static const STATIC : int = 2;
		public static const KINEMATIC : int = 4;
		public static const DEBRIS : int = 8;
		public static const SENSOR : int = 16;
		public static const CHARACTER : int = 32;
		public static const ALL : int = -1;
	}

}