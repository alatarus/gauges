package alatarus.components
{
	import alatarus.components.supportClasses.AnimationTarget;
	
	import spark.components.supportClasses.SkinnableComponent;
	import spark.effects.animation.Animation;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	
	/**
	 *  Duration in milliseconds for a animation.
	 */
	[Style(name="animationDuration", type="Number", format="Time", inherit="no")]
	
	/**
	 *  The GaugeBase class  is a base class for gauge components
	 * 
	 *  @langversion 3.0
	 *  @productversion Flex 4
	 */
	public class GaugeBase extends SkinnableComponent
	{
		/**
		 *  @private
		 */
		private const animator:Animation = new Animation();
		/**
		 *  @private
		 */
		private const motionPath:SimpleMotionPath = new SimpleMotionPath("value");
		
		/**
		 *  Constructor. 
		 *  
		 *  @langversion 3.0
		 *  @productversion Flex 4
		 */
		public function GaugeBase()
		{
			super();
			var animTarget:AnimationTarget = new AnimationTarget(animationUpdateHandler);
			
			animator.animationTarget = animTarget;
			animator.motionPaths = new <MotionPath>[motionPath];
		}
		
		protected var minChanged:Boolean = false;
		private var _minimum:Number = 0;

		/**
		 *  The minimum valid <code>value</code>.
		 * 
		 *  @default 0
		 *  @langversion 3.0
		 *  @productversion Flex 4
		 */
		public function get minimum():Number
		{
			return _minimum;
		}

		public function set minimum(value:Number):void
		{
			if (_minimum == value)
				return;
			
			_minimum = isNaN(value) ? 0 : value;
			minChanged = true;
			invalidateProperties();
		}

		protected var maxChanged:Boolean = false;
		private var _maximum:Number = 100;

		/**
		 *  The maximum valid <code>value</code>.
		 * 
		 *  @default 100
		 *  @langversion 3.0
		 *  @productversion Flex 4
		 */
		public function get maximum():Number
		{
			return _maximum;
		}

		public function set maximum(value:Number):void
		{
			if (_maximum == value)
				return;
			
			_maximum = isNaN(value) ? 100 : value;
			maxChanged = true;
			invalidateProperties();
		}

		protected var valueChanged:Boolean = false;
		private var _value:Number = 0;

		/**
		 *  The current value for this range.
		 *  
		 *  <p>Changes to the value property are constrained
		 *  by <code>commitProperties()</code> to be greater than or equal to
		 *  the <code>minimum</code> property, less than or equal to the <code>maximum</code> property, and a
		 *  multiple of <code>snapInterval</code> with the <code>nearestValidValue()</code>
		 *  method.</p> 
		 * 
		 *  @default 0
		 *  
		 *  @langversion 3.0
		 *  @productversion Flex 4
		 */
		public function get value():Number
		{
			return _value;
		}

		public function set value(value:Number):void
		{
			if (_value == value)
				return;
			
			_value = isNaN(value) ? 0 : value;
			valueChanged = true;
			invalidateProperties();
		}

		private var _utilization:Number = 0;

		/**
		 *  The current value of the percentage between the minimum and maximum values.
		 *  This property  also holds the temporary values set during an animation; the real value is only set
		 *  when the animation ends.
		 */
		protected function get utilization():Number
		{
			return _utilization;
		}

		protected function set utilization(value:Number):void
		{
			if (_utilization == value)
				return;
			
			_utilization = value;
		}
		
		/**
		 *  @private
		 */
		private function animateTo(value:Number):void
		{
			if (animator.isPlaying)
				animator.stop();
			
			var duration:Number = getStyle("animationDuration");
			
			if (duration != 0)
			{
				animator.duration = duration;
				motionPath.valueFrom = utilization;
				motionPath.valueTo = value;
				animator.play();
			}
			else
			{
				utilization = value;
			}
		}
		
		/**
		 *  @private
		 */
		protected function animationUpdateHandler(animation:Animation):void
		{
			utilization = animation.currentValue["value"];
		}

		/**
		 *  @private
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (minChanged)
			{
				_maximum = Math.max(_minimum, _maximum);
			}
			else if (maxChanged)
			{
				_minimum = Math.min(_minimum, _maximum);
			}
			
			if (valueChanged)
			{
				_value = Math.max(_minimum, Math.min(_value, _maximum));
			}
			
			if (minChanged || maxChanged || valueChanged)
			{
				minChanged = false;
				maxChanged = false;
				valueChanged = false;
				animateTo(_value == 0 ? 0 : _value / (_maximum - _minimum));
			}
		}
	}
}