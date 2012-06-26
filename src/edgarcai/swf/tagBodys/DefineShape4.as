//DefineShape4
//DefineShape4 extends the capabilities of DefineShape3 by using a new line style record in the
//shape. LINESTYLE2 allows new types of joins and caps as well as scaling options and the
//ability to fill a stroke.
//
//DefineShape4 specifies not only the shape bounds but also the edge bounds of the shape.
//While the shape bounds are calculated along the outside of the strokes, the edge bounds are
//taken from the outside of the edges, as shown in the following diagram. The EdgeBounds
//field assists Flash Player in accurately determining certain layouts.
//
//In addition, DefineShape4 includes new hinting flags UsesNonScalingStrokes and
//UsesScalingStrokes. These flags assist Flash Player in creating the best possible area for
//invalidation.
//The minimum file format version is SWF 8.
//
//DefineShape4
//Field 					Type 			Comment
//Header 					RECORDHEADER 	Tag type = 83.
//ShapeId 					UI16 			ID for this character.
//ShapeBounds 				RECT 			Bounds of the shape.
//EdgeBounds 				RECT 			Bounds of the shape, excluding strokes.
//Reserved 					UB[5] 			Must be 0.
//UsesFillWindingRule 		UB[1] 			If 1, use fill winding rule.
//											Minimum file format version is SWF 10
//UsesNonScalingStrokes 	UB[1] 			If 1, the shape contains at least one non-scaling stroke.
//UsesScalingStrokes 		UB[1] 			If 1, the shape contains at least one scaling stroke.
//Shapes 					SHAPEWITHSTYLE 	Shape information.

package edgarcai.swf.tagBodys{
	
	import flash.utils.ByteArray;
	import edgarcai.swf.records.RECT;
	import edgarcai.swf.records.shapes.SHAPEWITHSTYLE;
	
	public class DefineShape4{
		
		public var id:int;//UI16
		public var ShapeBounds:RECT;
		public var EdgeBounds:RECT;
		//public var Reserved:int;//11111000
		public var UsesFillWindingRule:Boolean;//00000100
		public var UsesNonScalingStrokes:Boolean;//00000010
		public var UsesScalingStrokes:Boolean;//00000001
		public var Shapes:SHAPEWITHSTYLE;
		
		public function initByData(data:ByteArray,offset:int,endOffset:int,_initByDataOptions:Object):int{
			
			if(_initByDataOptions){
			}else{
				_initByDataOptions=new Object();
			}
			_initByDataOptions.ColorUseRGBA=true;//20110813
			_initByDataOptions.LineStyleUseLINESTYLE2=true;//20110814
			
			var flags:int;
			
			id=data[offset++]|(data[offset++]<<8);
			
			ShapeBounds=new RECT();
			offset=ShapeBounds.initByData(data,offset,endOffset,_initByDataOptions);
			
			EdgeBounds=new RECT();
			offset=EdgeBounds.initByData(data,offset,endOffset,_initByDataOptions);
			
			flags=data[offset++];
			//Reserved=flags&0xf8;//11111000
			UsesFillWindingRule=((flags&0x04)?true:false);//00000100
			UsesNonScalingStrokes=((flags&0x02)?true:false);//00000010
			UsesScalingStrokes=((flags&0x01)?true:false);//00000001
			
			Shapes=new SHAPEWITHSTYLE();
			return Shapes.initByData(data,offset,endOffset,_initByDataOptions);
			
		}
		public function toData(_toDataOptions:Object):ByteArray{
			
			if(_toDataOptions){
			}else{
				_toDataOptions=new Object();
			}
			_toDataOptions.ColorUseRGBA=true;//20110813
			
			var flags:int;
			
			var data:ByteArray=new ByteArray();
			
			data[0]=id;
			data[1]=id>>8;
			
			data.position=2;
			data.writeBytes(ShapeBounds.toData(_toDataOptions));
			
			data.writeBytes(EdgeBounds.toData(_toDataOptions));
			
			flags=0;
			//flags|=Reserved;//11111000
			if(UsesFillWindingRule){
				flags|=0x04;//00000100
			}
			if(UsesNonScalingStrokes){
				flags|=0x02;//00000010
			}
			if(UsesScalingStrokes){
				flags|=0x01;//00000001
			}
			data[data.length]=flags;
			
			data.position=data.length;
			data.writeBytes(Shapes.toData(_toDataOptions));
			
			return data;
			
		}
		
		public function toXML(xmlName:String,_toXMLOptions:Object):XML{
			
			if(_toXMLOptions){
			}else{
				_toXMLOptions=new Object();
			}
			_toXMLOptions.ColorUseRGBA=true;//20110813
			
			var xml:XML=<{xmlName} class="edgarcai.swf.tagBodys.DefineShape4"
				id={id}
			UsesFillWindingRule={UsesFillWindingRule}
			UsesNonScalingStrokes={UsesNonScalingStrokes}
			UsesScalingStrokes={UsesScalingStrokes}
			/>;
			
			xml.appendChild(ShapeBounds.toXML("ShapeBounds",_toXMLOptions));
			
			xml.appendChild(EdgeBounds.toXML("EdgeBounds",_toXMLOptions));
			
			xml.appendChild(Shapes.toXML("Shapes",_toXMLOptions));
			
			return xml;
			
		}
		public function initByXML(xml:XML,_initByXMLOptions:Object):void{
			
			id=int(xml.@id.toString());
			
			ShapeBounds=new RECT();
			ShapeBounds.initByXML(xml.ShapeBounds[0],_initByXMLOptions);
			
			EdgeBounds=new RECT();
			EdgeBounds.initByXML(xml.EdgeBounds[0],_initByXMLOptions);
			
			UsesFillWindingRule=(xml.@UsesFillWindingRule.toString()=="true");
			UsesNonScalingStrokes=(xml.@UsesNonScalingStrokes.toString()=="true");
			UsesScalingStrokes=(xml.@UsesScalingStrokes.toString()=="true");
			
			Shapes=new SHAPEWITHSTYLE();
			Shapes.initByXML(xml.Shapes[0],_initByXMLOptions);
			
		}
	}
}