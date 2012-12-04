package alatarus.components
{
	import mx.core.IFactory;
	import mx.core.IVisualElement;
	
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.supportClasses.TextBase;
	
	public class GaugeAxis extends SkinnableComponent
	{
		[SkinPart(required="false", type="mx.core.IVisualElement")]
		public var majorTickPart:IFactory;
		
		[SkinPart(required="false", type="mx.core.IVisualElement")]
		public var minorTickPart:IFactory;
		
		[SkinPart(required="false", type="spark.components.supportClasses.TextBase")]
		public var labelPart:IFactory;
		
		[SkinPart(required="false")]
		public var ticksDisplay:Group;
		
		[SkinPart(required="false")]
		public var labelsDisplay:Group;
		
		private var _ticksAndLabelsDirty:Boolean = false;
		
		public function GaugeAxis()
		{
			super();
		}
		
		private var _updateText:Boolean = true;
		private var _labelFunction:Function;

		public function get labelFunction():Function
		{
			return _labelFunction;
		}

		public function set labelFunction(value:Function):void
		{
			if (_labelFunction === value)
				return;
			
			_labelFunction = value;
			_updateText = true;
			invalidateProperties();
		}
		
		private var _labelPrecision:int = 0;

		public function get labelPrecision():int
		{
			return _labelPrecision;
		}

		public function set labelPrecision(value:int):void
		{
			if (_labelPrecision == value)
				return;
			
			_labelPrecision = Math.max(Math.min(value, 20), 0);
			_updateText = true;
			invalidateProperties();
		}

		private var _minimum:Number = 0;

		public function get minimum():Number
		{
			return _minimum;
		}

		public function set minimum(value:Number):void
		{
			if (_minimum == value)
				return;
			
			_minimum = value;
			_ticksAndLabelsDirty = true;
			invalidateProperties();
		}

		private var _maximum:Number = 100;

		public function get maximum():Number
		{
			return _maximum;
		}

		public function set maximum(value:Number):void
		{
			if (_maximum == value)
				return;
			
			_maximum = value;
			_ticksAndLabelsDirty = true;
			invalidateProperties();
		}

		private var _stepSize:Number = 10;

		public function get stepSize():Number
		{
			return _stepSize;
		}

		public function set stepSize(value:Number):void
		{
			if (_stepSize == value)
				return;
			
			_stepSize = value;
			_ticksAndLabelsDirty = true;
			invalidateProperties();
		}
		
		private function updateLabels():void
		{
			if (!labelsDisplay)
				return;
		}
		
		private function createLabels():Array
		{
			if (!labelPart)
				return [];
			
			var numItems:int = (maximum - minimum)/stepSize + 1;
			var labels:Array = [];
			var labelInstance:TextBase;
			
			for (var i:int = 0; i < numItems; i++)
			{
				labelInstance = labelPart.newInstance();
				labelInstance.text = valueToString(stepSize * i);
				labels.push(labelInstance);
			}
			
			return labels;
		}
		
		private function createTicks():Array
		{
			if (majorTickPart == null)
				return [];
			
			var numMajorTicks:int = (maximum - minimum)/stepSize;
			var numMinorThicks:int = minorTickPart != null ? int(stepSize / 3) : 0;
			var majorTickInstance:IVisualElement;
			var minorTickInstance:IVisualElement;
			
			var ticks:Array = [];
			
			for (var i:int = 0; i < numMajorTicks; i++)
			{
				majorTickInstance = majorTickPart.newInstance();
				ticks.push(majorTickInstance);
				
				for (var j:int = 0; j < numMinorThicks; j++)
				{
					minorTickInstance = minorTickPart.newInstance();
					ticks.push(minorTickInstance);
				}
			}
			
			majorTickInstance = majorTickPart.newInstance();
			ticks.push(majorTickInstance);
			
			return ticks;
		}
		
		private function valueToString(value:Number):String
		{
			if (labelFunction != null)
			{
				return labelFunction(value);
			}
			else if (labelPrecision != 0)
			{
					return (value).toFixed(labelPrecision);
			}
			
			return Math.round(value).toString();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (_ticksAndLabelsDirty)
			{
				_ticksAndLabelsDirty = false;
				_updateText = false;
				
				if (ticksDisplay)
				{
					ticksDisplay.mxmlContent = createTicks();
				}
				
				if (labelsDisplay)
				{
					labelsDisplay.mxmlContent = createLabels();
				}
			}
			else if (_updateText)
			{
				
			}
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if (ticksDisplay)
			{
				ticksDisplay.mxmlContent = createTicks();
			}
			
			if (labelsDisplay)
			{
				labelsDisplay.mxmlContent = createLabels();
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance === ticksDisplay)
			{
				ticksDisplay.mxmlContent = createTicks();
			}
			else if (instance === labelsDisplay)
			{
				labelsDisplay.mxmlContent = createLabels();
			}
		}
	}
}