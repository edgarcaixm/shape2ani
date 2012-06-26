package
{
	import edgarcai.*;
	import edgarcai.swf.*;
	import edgarcai.swf.Tag;
	import edgarcai.swf.records.*;
	import edgarcai.swf.records.shapes.*;
	import edgarcai.swf.tagBodys.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.common.events.ParticleEvent;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.twoD.actions.DeathZone;
	import org.flintparticles.twoD.actions.Explosion;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.particles.Particle2DUtils;
	import org.flintparticles.twoD.renderers.DisplayObjectRenderer;
	import org.flintparticles.twoD.zones.RectangleZone;
	
	
	/**
	 * 解析swf的图形，并转换为动画 
	 * @author edgarcai
	 * 
	 */	
	
	[Frame(factoryClass="Preloader")]
	[SWF(width="800", height="600", backgroundColor="#CCCCCC", frameRate="60")]
	public class Main extends Sprite
	{
		private var arr:Array;
		private var ShapesId:int;
		private var intervalId:int;
		private var timeoutId:int;
		private var recordId:int;
		
		private var tag_type:int;
		private var Shapes:SHAPEWITHSTYLE;
		
		private var currX:int;
		private var currY:int;
		private var currFillStyleV:Vector.<FILLSTYLE>;
		private var currLineStyle2V:Vector.<LINESTYLE2>;
		private var currLineStyleV:Vector.<LINESTYLE>;
		
		private var _sampleloader:URLLoader;
		private var _msg:TextField = new TextField();
		
		private var emitter:Emitter2D;
		private var bitmap:BitmapData;
		private var renderer:DisplayObjectRenderer;
		private var explosion:Explosion;
		
		public function Main()
		{
			if(!stage)
			{
				this.addEventListener(Event.ADDED_TO_STAGE,startup);
			}else
			{
				startup();
			}
		}
		
		/**
		 * 初始化
		 * @param event
		 * 
		 */		
		protected function startup(event:Event=null):void
		{
			if(event)
			{
				this.removeEventListener(Event.ADDED_TO_STAGE,startup);
			}
			_sampleloader = new URLLoader();
			_sampleloader.dataFormat = URLLoaderDataFormat.BINARY;
			_sampleloader.addEventListener(Event.COMPLETE,loadSampleComplete);
			_sampleloader.addEventListener(ProgressEvent.PROGRESS,onloading);
			_sampleloader.load(new URLRequest("data/zhangfei2.swf"));
			_msg.x = _msg.y = 10;
			_msg.width = 1000;
			this.addChild(_msg);
			
			/**
			 * 粒子效果 
			 */ 
			bitmap = new Image1();
			emitter = new Emitter2D();
			emitter.addAction( new DeathZone( new RectangleZone( -5, -5, 805, 605 ), true ) );
			emitter.addAction( new Move() );
			prepare();
			
			renderer = new DisplayObjectRenderer();
			addChild( renderer );
			renderer.addEmitter( emitter );
			emitter.start();
			
			stage.addEventListener( MouseEvent.CLICK, explode, false, 0, true );
			//emitter.addEventListener( EmitterEvent.EMITTER_EMPTY, prepare );
		}
		
		protected function explode(ev:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.CLICK, explode );
			if( !explosion )
			{
				var p:Point = renderer.globalToLocal( new Point( ev.stageX, ev.stageY ) );
				explosion = new Explosion( 5, p.x, p.y, 500 );
				emitter.addAction( explosion );
			}
			start(_sampleloader.data);
		}
		
		protected function prepare(event:EmitterEvent = null):void
		{
			if( explosion )
			{
				emitter.removeAction( explosion );
				explosion = null;
			}
			var particles:Vector.<Particle> = Particle2DUtils.createRectangleParticlesFromBitmapData( bitmap, 8, emitter.particleFactory, 56, 47 );
			emitter.addParticles( particles, false );
		}
		
		protected function onloading(event:ProgressEvent):void
		{
			var per:Number = Math.floor(event.bytesLoaded/event.bytesTotal*100); 
			_msg.text = "已加载"+per+"%";
		}
		
		protected function loadSampleComplete(event:Event):void
		{
			//start(_sampleloader.data);
			_sampleloader.removeEventListener(Event.COMPLETE,loadSampleComplete);
			//_sampleloader=null;
		}
		
		private function start(swfData:ByteArray):void{
			var swf:SWF=new SWF();
			swf.initBySWFData(swfData,null);
			trace("start");
			arr=new Array();
			for each(var tag:Tag in swf.tagV){
				switch(tag.type){
					case TagTypes.DefineShape:
						var defineShape:DefineShape=tag.getBody(DefineShape,null);
						arr.push([tag.type,defineShape.ShapeBounds,defineShape.Shapes]);
						break;	
					case TagTypes.DefineShape2:
						var defineShape2:DefineShape2=tag.getBody(DefineShape2,null);
						arr.push([tag.type,defineShape2.ShapeBounds,defineShape2.Shapes]);
						break;	
					case TagTypes.DefineShape3:
						var defineShape3:DefineShape3=tag.getBody(DefineShape3,null);
						arr.push([tag.type,defineShape3.ShapeBounds,defineShape3.Shapes]);
						break;	
					case TagTypes.DefineShape4:
						var defineShape4:DefineShape4=tag.getBody(DefineShape4,null);
						arr.push([tag.type,defineShape4.ShapeBounds,defineShape4.Shapes]);
						break;
				}
			}
			
			ShapesId=-1;
			nextShapes();
		}
		
		private function nextShapes():void{
			clearTimeout(timeoutId);
			clearInterval(intervalId);
			if(++ShapesId>=arr.length){
				return;
			}
			var rect_x:Number=arr[ShapesId][1].Xmin/20;
			var rect_y:Number=arr[ShapesId][1].Ymin/20;
			var rect_wid:Number=arr[ShapesId][1].Xmax/20-rect_x;
			var rect_hei:Number=arr[ShapesId][1].Ymax/20-rect_y;
			this.graphics.clear();
			this.graphics.beginFill(0x000000,0);
			this.graphics.drawRect(rect_x,rect_y,rect_wid,rect_hei);
			this.graphics.endFill();
			
			tag_type==arr[ShapesId][0];
			Shapes=arr[ShapesId][2];
			
			currX=0;
			currY=0;
			
			currFillStyleV=Shapes.FillStyleV;
			currLineStyle2V=Shapes.LineStyle2V;
			currLineStyleV=Shapes.LineStyleV;
			
			recordId=-1;
			//intervalId=setInterval(nextEdge,30);
			intervalId=setInterval(nextEdge,10);
		}
		
		private function nextEdge():void{
			if(++recordId>=Shapes.ShapeRecordV.length){
				//nextShapes();
				timeoutId=setTimeout(nextShapes,2000);
				return;
			}
			_msg.text = "第"+recordId+"/"+(Shapes.ShapeRecordV.length-1)+"画";
			var LineStyle:LINESTYLE,LineStyle2:LINESTYLE2,FillStyle:FILLSTYLE;
			
			var ShapeRecord:SHAPERECORD=Shapes.ShapeRecordV[recordId];
			switch(ShapeRecord.type){
				case ShapeRecordTypes.STRAIGHTEDGERECORD:
					currX+=ShapeRecord.DeltaX;
					currY+=ShapeRecord.DeltaY;
					this.graphics.lineTo(currX/20,currY/20);
					break;
				case ShapeRecordTypes.CURVEDEDGERECORD:
					var controlX:int=currX+ShapeRecord.ControlDeltaX;
					var controlY:int=currY+ShapeRecord.ControlDeltaY;
					currX=controlX+ShapeRecord.AnchorDeltaX;
					currY=controlY+ShapeRecord.AnchorDeltaY;
					this.graphics.curveTo(controlX/20,controlY/20,currX/20,currY/20);
					break;
				case ShapeRecordTypes.STYLECHANGERECORD:
					
					if(ShapeRecord.MoveDeltaXY){
						currX=ShapeRecord.MoveDeltaXY[0];
						currY=ShapeRecord.MoveDeltaXY[1];
						this.graphics.moveTo(currX/20,currY/20);
					}
					if(ShapeRecord.FillStyle0>-1){
						///
					}
					if(ShapeRecord.FillStyle1>-1){
						///
					}
					if(ShapeRecord.LineStyle>-1){
						if(ShapeRecord.LineStyle){
							switch(tag_type){
								case TagTypes.DefineShape:
								case TagTypes.DefineShape2:
									LineStyle=currLineStyleV[ShapeRecord.LineStyle-1];
									this.graphics.lineStyle(LineStyle.Width/20,LineStyle.Color,1);
									break;
								case TagTypes.DefineShape3:
									LineStyle=currLineStyleV[ShapeRecord.LineStyle-1];
									this.graphics.lineStyle(LineStyle.Width/20,LineStyle.Color&0x00ffffff,(LineStyle.Color>>>24)/0xff);
									break;
								case TagTypes.DefineShape4:
									LineStyle2=currLineStyle2V[ShapeRecord.LineStyle-1];
									if(LineStyle2.FillType){
										///
										this.graphics.lineStyle(LineStyle2.Width/20,0xff0000);
									}else{
										this.graphics.lineStyle(LineStyle2.Width/20,LineStyle2.Color&0x00ffffff,(LineStyle2.Color>>>24)/0xff);
									}
									break;
							}
						}else{
							this.graphics.lineStyle(0x000000,0.1);
						}
					}else{
						this.graphics.lineStyle(0x000000,0.1);
					}
					if(ShapeRecord.FillStyleV&&ShapeRecord.FillStyleV.length){
						currFillStyleV=ShapeRecord.FillStyleV;
					}
					if(ShapeRecord.LineStyle2V&&ShapeRecord.LineStyle2V.length){
						currLineStyle2V=ShapeRecord.LineStyle2V;
					}
					if(ShapeRecord.LineStyleV&&ShapeRecord.LineStyleV.length){
						currLineStyleV=ShapeRecord.LineStyleV;
					}
					break;
				case ShapeRecordTypes.ENDSHAPERECORD:
					recordId=Shapes.ShapeRecordV.length;
					return;
			}
		}
	}
}