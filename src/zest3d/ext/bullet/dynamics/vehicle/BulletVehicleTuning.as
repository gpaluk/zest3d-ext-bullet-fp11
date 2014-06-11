package zest3d.ext.bullet.dynamics.vehicle 
{
	/**
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletVehicleTuning 
	{
		
		public var suspensionStiffness : Number;
		public var suspensionCompression : Number;
		public var suspensionDamping : Number;
		public var maxSuspensionTravelCm : Number;
		public var frictionSlip : Number;
		public var maxSuspensionForce : Number;
		
		public function BulletVehicleTuning() 
		{
			suspensionStiffness = 5.88;
			suspensionCompression = 0.83;
			suspensionDamping = 0.88;
			maxSuspensionTravelCm = 500;
			frictionSlip = 10.5;
			maxSuspensionForce = 6000;
		}
		
	}

}