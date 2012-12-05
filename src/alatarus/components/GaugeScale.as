package alatarus.components
{
	import mx.core.IFactory;
	import mx.core.IVisualElement;
	
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.supportClasses.TextBase;
	
	public class GaugeScale extends SkinnableComponent
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
		
		private var _ticksDirty:Boolean = false;
		private var _labelsDirty:Boolean = false;
		
		public function GaugeScale()
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
		
		private var _minorTickCount:int = 3;

		public function get minorTickCount():int
		{
			return _minorTickCount;
		}

		public function set minorTickCount(value:int):void
		{
			if (_minorTickCount == value)
				return;
			
			_minorTickCount = value < 0 ? 0 : value;
			_ticksDirty = true;
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
			_ticksDirty = true;
			_labelsDirty = true;
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
			_ticksDirty = true;
			_labelsDirty = true;
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
			_ticksDirty = true;
			_labelsDirty = true;
			invalidateProperties();
		}
		
		private function updateLabels():void
		{
			if (!labelsDisplay)
				return;
			
			for (var i:int = 0; i < labelsDisplay.numElements; i++)
			{
				var labelInstance:TextBase = TextBase(labelsDisplay.getElementAt(i));
				labelInstance.text = valueToString(stepSize * i);
			}
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
			var numMinorThicks:int = minorTickPart != null ? minorTickCount : 0;
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
			
			if (_ticksDirty)
			{
				_ticksDirty = false;
				
				if (ticksDisplay)
				{
					ticksDisplay.mxmlContent = createTicks();
				}
			}
			
			if (_labelsDirty)
			{
				_labelsDirty = false;
				_updateText = false;
				
				if (labelsDisplay)
				{
					labelsDisplay.mxmlContent = createLabels();
				}
			}
			else if (_updateText)
			{
				updateLabels();
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