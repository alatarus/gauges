package alatarus.components
{
	import flash.geom.Matrix;
	
	import mx.core.UIComponent;

	/**
	 *  The circular gauge control
	 */
	public class CircularGauge extends GaugeBase
	{
		[SkinPart(required="false")]
		public var marker:UIComponent;
		
		[SkinPart(required="false")]
		public var axis:GaugeAxis;
		
		/**
		 *  @private
		 */
		private static const TO_RADIAN:Number = Math.PI / 180;
		
		/**
		 *  Transformation matrix for the marker.
		 * 
		 *  @private
		 */
		private var _transformMatrix:Matrix = new Matrix();
		
		/**
		 *  Constructor. 
		 *  
		 *  @langversion 3.0
		 *  @productversion Flex 4
		 */
		public function CircularGauge()
		{
			super();
		}
		
		private var _startAngle:Number = -180;

		/**
		 * The angle of minimum value.
		 */
		public function get startAngle():Number
		{
			return _startAngle;
		}

		public function set startAngle(value:Number):void
		{
			if (_startAngle == value)
				return;
			
			_startAngle = value;
		}

		private var _endAngle:Number = 0;

		/**
		 *  The angle of maximum value.
		 */
		public function get endAngle():Number
		{
			return _endAngle;
		}

		public function set endAngle(value:Number):void
		{
			if (_endAngle == value)
				return;
			
			_endAngle = value;
		}
		
		/**
		 *  @private
		 */
		private function resetMatrix():void
		{
			_transformMatrix.a = 1;
			_transformMatrix.b = 0;
			_transformMatrix.c = 0;
			_transformMatrix.d = 1;
			_transformMatrix.tx = 0;
			_transformMatrix.ty = 0;
		}

		/**
		 *  Returns the angle between the startAngle and endAngle values in degrees.
		 * 
		 *  @param value The input in percent.
		 *  @return The angle between the startAngle and endAngle values in degrees.
		 * 
		 */
		protected function toAngle(value:Number):Number
		{
			return startAngle + (endAngle - startAngle) * value;
		}
		
		private function rotateMarker(value:Number):void
		{
			if (!marker)
				return;
			
			resetMatrix();
			_transformMatrix.translate(marker.transformX, marker.transformY);
			_transformMatrix.rotate(toAngle(value) * TO_RADIAN);
			_transformMatrix.translate(width * .5, height * .5);
			
			marker.transform.matrix = _transformMatrix;
		}
		
		/**
		 * @private
		 */
		override protected function set utilization(value:Number):void
		{
			super.utilization = value;
			rotateMarker(value);
		}
		
		/**
		 *  @private
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance === marker)
			{
				rotateMarker(utilization);
			}
			else if (instance === axis)
			{
				axis.minimum = minimum;
				axis.maximum = maximum;
			}
		}
		
		override protected function commitProperties():void
		{
			if (axis && (minChanged || maxChanged))
			{
				super.commitProperties();
				axis.minimum = minimum;
				axis.maximum = maximum;
			}
			else
			{
				super.commitProperties();
			}
		}
	}
}