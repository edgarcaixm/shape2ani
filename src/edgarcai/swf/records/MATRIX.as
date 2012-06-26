package edgarcai.swf.records{
	import flash.utils.ByteArray;
	public class MATRIX{
		public var HasScale:Boolean;
		public var ScaleX:int;
		public var ScaleY:int;
		public var HasRotate:Boolean;
		public var RotateSkew0:int;
		public var RotateSkew1:int;
		public var TranslateX:int;
		public var TranslateY:int;
		
		public function initByData(data:ByteArray,offset:int,endOffset:int,_initByDataOptions:Object):int{
			var bGroupValue:int=(data[offset++]<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];
			HasScale=((bGroupValue&0x80000000)?true:false);						//10000000 00000000 00000000 00000000
			
			var bGroupBitsOffset:int=1;
			
			if(HasScale){
				var NScaleBits:int=(bGroupValue<<1)>>>27;				//01111100 00000000 00000000 00000000
				bGroupBitsOffset=6;
				
				
				if(NScaleBits){
					var bGroupRshiftBitsOffset:int=32-NScaleBits;
					var bGroupNegMask:int=1<<(NScaleBits-1);
					var bGroupNeg:int=0xffffffff<<NScaleBits;
					
					ScaleX=(bGroupValue<<6)>>>bGroupRshiftBitsOffset;
					if(ScaleX&bGroupNegMask){ScaleX|=bGroupNeg;}//最高位为1,表示负数
					bGroupBitsOffset+=NScaleBits;
					
					//从 data 读取足够多的位数以备下面使用:
					if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
					
					ScaleY=(bGroupValue<<bGroupBitsOffset)>>>bGroupRshiftBitsOffset;
					if(ScaleY&bGroupNegMask){ScaleY|=bGroupNeg;}//最高位为1,表示负数
					bGroupBitsOffset+=NScaleBits;
					
					//从 data 读取足够多的位数以备下面使用:
					if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
					
				}
			}
			
			HasRotate=(((bGroupValue<<bGroupBitsOffset)>>>31)?true:false);
			++bGroupBitsOffset;
			
			//从 data 读取足够多的位数以备下面使用:
			if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
			
			
			if(HasRotate){
				var NRotateBits:int=(bGroupValue<<bGroupBitsOffset)>>>27;
				bGroupBitsOffset+=5;
				
				//从 data 读取足够多的位数以备下面使用:
				if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
				
				
				if(NRotateBits){
					bGroupRshiftBitsOffset=32-NRotateBits;
					bGroupNegMask=1<<(NRotateBits-1);
					bGroupNeg=0xffffffff<<NRotateBits;
					
					RotateSkew0=(bGroupValue<<bGroupBitsOffset)>>>bGroupRshiftBitsOffset;
					if(RotateSkew0&bGroupNegMask){RotateSkew0|=bGroupNeg;}//最高位为1,表示负数
					bGroupBitsOffset+=NRotateBits;
					
					//从 data 读取足够多的位数以备下面使用:
					if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
					
					RotateSkew1=(bGroupValue<<bGroupBitsOffset)>>>bGroupRshiftBitsOffset;
					if(RotateSkew1&bGroupNegMask){RotateSkew1|=bGroupNeg;}//最高位为1,表示负数
					bGroupBitsOffset+=NRotateBits;
					
					//从 data 读取足够多的位数以备下面使用:
					if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
					
				}
			
			}
			var NTranslateBits:int=(bGroupValue<<bGroupBitsOffset)>>>27;
			bGroupBitsOffset+=5;
			
			//从 data 读取足够多的位数以备下面使用:
			if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
			
			
			if(NTranslateBits){
				bGroupRshiftBitsOffset=32-NTranslateBits;
				bGroupNegMask=1<<(NTranslateBits-1);
				bGroupNeg=0xffffffff<<NTranslateBits;
				
				TranslateX=(bGroupValue<<bGroupBitsOffset)>>>bGroupRshiftBitsOffset;
				if(TranslateX&bGroupNegMask){TranslateX|=bGroupNeg;}//最高位为1,表示负数
				bGroupBitsOffset+=NTranslateBits;
				
				//从 data 读取足够多的位数以备下面使用:
				if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
				
				TranslateY=(bGroupValue<<bGroupBitsOffset)>>>bGroupRshiftBitsOffset;
				if(TranslateY&bGroupNegMask){TranslateY|=bGroupNeg;}//最高位为1,表示负数
				bGroupBitsOffset+=NTranslateBits;
			}
			
			return offset-int(4-bGroupBitsOffset/8);
		}
		public function toData(_toDataOptions:Object):ByteArray{
			var data:ByteArray=new ByteArray();
			var bGroupValue:int=0;
			var offset:int=0;
			if(HasScale){
				bGroupValue|=0x80000000;					//10000000 00000000 00000000 00000000
			}
			
			var bGroupBitsOffset:int=1;
			
			if(HasScale){
			
				//计算所需最小位数:
				var bGroupMixNum:int=((ScaleX<0?-ScaleX:ScaleX)<<1)|((ScaleY<0?-ScaleY:ScaleY)<<1);
				if(bGroupMixNum>>>16){if(bGroupMixNum>>>24){if(bGroupMixNum>>>28){if(bGroupMixNum>>>30){if(bGroupMixNum>>>31){var NScaleBits:int=32;}else{NScaleBits=31;}}else{if(bGroupMixNum>>>29){NScaleBits=30;}else{NScaleBits=29;}}}else{if(bGroupMixNum>>>26){if(bGroupMixNum>>>27){NScaleBits=28;}else{NScaleBits=27;}}else{if(bGroupMixNum>>>25){NScaleBits=26;}else{NScaleBits=25;}}}}else{if(bGroupMixNum>>>20){if(bGroupMixNum>>>22){if(bGroupMixNum>>>23){NScaleBits=24;}else{NScaleBits=23;}}else{if(bGroupMixNum>>>21){NScaleBits=22;}else{NScaleBits=21;}}}else{if(bGroupMixNum>>>18){if(bGroupMixNum>>>19){NScaleBits=20;}else{NScaleBits=19;}}else{if(bGroupMixNum>>>17){NScaleBits=18;}else{NScaleBits=17;}}}}}else{if(bGroupMixNum>>>8){if(bGroupMixNum>>>12){if(bGroupMixNum>>>14){if(bGroupMixNum>>>15){NScaleBits=16;}else{NScaleBits=15;}}else{if(bGroupMixNum>>>13){NScaleBits=14;}else{NScaleBits=13;}}}else{if(bGroupMixNum>>>10){if(bGroupMixNum>>>11){NScaleBits=12;}else{NScaleBits=11;}}else{if(bGroupMixNum>>>9){NScaleBits=10;}else{NScaleBits=9;}}}}else{if(bGroupMixNum>>>4){if(bGroupMixNum>>>6){if(bGroupMixNum>>>7){NScaleBits=8;}else{NScaleBits=7;}}else{if(bGroupMixNum>>>5){NScaleBits=6;}else{NScaleBits=5;}}}else{if(bGroupMixNum>>>2){if(bGroupMixNum>>>3){NScaleBits=4;}else{NScaleBits=3;}}else{if(bGroupMixNum>>>1){NScaleBits=2;}else{NScaleBits=bGroupMixNum;}}}}}
				
				bGroupValue|=NScaleBits<<26;					//01111100 00000000 00000000 00000000
				bGroupBitsOffset=6;
				
				var bGroupRshiftBitsOffset:int=32-NScaleBits;
				bGroupValue|=(ScaleX<<bGroupRshiftBitsOffset)>>>6;
				bGroupBitsOffset+=NScaleBits;
				
				//向 data 写入满8位(1字节)的数据:
				if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
				
				bGroupValue|=(ScaleY<<bGroupRshiftBitsOffset)>>>bGroupBitsOffset;
				bGroupBitsOffset+=NScaleBits;
				
				//向 data 写入满8位(1字节)的数据:
				if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
				
			}
			
			++bGroupBitsOffset;
			if(HasRotate){
				bGroupValue|=(1<<(32-bGroupBitsOffset));
			}
			
			//向 data 写入满8位(1字节)的数据:
			if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
			
			
			if(HasRotate){
			
				//计算所需最小位数:
				bGroupMixNum=((RotateSkew0<0?-RotateSkew0:RotateSkew0)<<1)|((RotateSkew1<0?-RotateSkew1:RotateSkew1)<<1);
				if(bGroupMixNum>>>16){if(bGroupMixNum>>>24){if(bGroupMixNum>>>28){if(bGroupMixNum>>>30){if(bGroupMixNum>>>31){var NRotateBits:int=32;}else{NRotateBits=31;}}else{if(bGroupMixNum>>>29){NRotateBits=30;}else{NRotateBits=29;}}}else{if(bGroupMixNum>>>26){if(bGroupMixNum>>>27){NRotateBits=28;}else{NRotateBits=27;}}else{if(bGroupMixNum>>>25){NRotateBits=26;}else{NRotateBits=25;}}}}else{if(bGroupMixNum>>>20){if(bGroupMixNum>>>22){if(bGroupMixNum>>>23){NRotateBits=24;}else{NRotateBits=23;}}else{if(bGroupMixNum>>>21){NRotateBits=22;}else{NRotateBits=21;}}}else{if(bGroupMixNum>>>18){if(bGroupMixNum>>>19){NRotateBits=20;}else{NRotateBits=19;}}else{if(bGroupMixNum>>>17){NRotateBits=18;}else{NRotateBits=17;}}}}}else{if(bGroupMixNum>>>8){if(bGroupMixNum>>>12){if(bGroupMixNum>>>14){if(bGroupMixNum>>>15){NRotateBits=16;}else{NRotateBits=15;}}else{if(bGroupMixNum>>>13){NRotateBits=14;}else{NRotateBits=13;}}}else{if(bGroupMixNum>>>10){if(bGroupMixNum>>>11){NRotateBits=12;}else{NRotateBits=11;}}else{if(bGroupMixNum>>>9){NRotateBits=10;}else{NRotateBits=9;}}}}else{if(bGroupMixNum>>>4){if(bGroupMixNum>>>6){if(bGroupMixNum>>>7){NRotateBits=8;}else{NRotateBits=7;}}else{if(bGroupMixNum>>>5){NRotateBits=6;}else{NRotateBits=5;}}}else{if(bGroupMixNum>>>2){if(bGroupMixNum>>>3){NRotateBits=4;}else{NRotateBits=3;}}else{if(bGroupMixNum>>>1){NRotateBits=2;}else{NRotateBits=bGroupMixNum;}}}}}
				
				bGroupValue|=NRotateBits<<(32-(bGroupBitsOffset+=5));
				
				//向 data 写入满8位(1字节)的数据:
				if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
				
				bGroupRshiftBitsOffset=32-NRotateBits;
				bGroupValue|=(RotateSkew0<<bGroupRshiftBitsOffset)>>>bGroupBitsOffset;
				bGroupBitsOffset+=NRotateBits;
				
				//向 data 写入满8位(1字节)的数据:
				if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
				
				bGroupValue|=(RotateSkew1<<bGroupRshiftBitsOffset)>>>bGroupBitsOffset;
				bGroupBitsOffset+=NRotateBits;
				
				//向 data 写入满8位(1字节)的数据:
				if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
				
			
			}
			
			//计算所需最小位数:
			bGroupMixNum=((TranslateX<0?-TranslateX:TranslateX)<<1)|((TranslateY<0?-TranslateY:TranslateY)<<1);
			if(bGroupMixNum>>>16){if(bGroupMixNum>>>24){if(bGroupMixNum>>>28){if(bGroupMixNum>>>30){if(bGroupMixNum>>>31){var NTranslateBits:int=32;}else{NTranslateBits=31;}}else{if(bGroupMixNum>>>29){NTranslateBits=30;}else{NTranslateBits=29;}}}else{if(bGroupMixNum>>>26){if(bGroupMixNum>>>27){NTranslateBits=28;}else{NTranslateBits=27;}}else{if(bGroupMixNum>>>25){NTranslateBits=26;}else{NTranslateBits=25;}}}}else{if(bGroupMixNum>>>20){if(bGroupMixNum>>>22){if(bGroupMixNum>>>23){NTranslateBits=24;}else{NTranslateBits=23;}}else{if(bGroupMixNum>>>21){NTranslateBits=22;}else{NTranslateBits=21;}}}else{if(bGroupMixNum>>>18){if(bGroupMixNum>>>19){NTranslateBits=20;}else{NTranslateBits=19;}}else{if(bGroupMixNum>>>17){NTranslateBits=18;}else{NTranslateBits=17;}}}}}else{if(bGroupMixNum>>>8){if(bGroupMixNum>>>12){if(bGroupMixNum>>>14){if(bGroupMixNum>>>15){NTranslateBits=16;}else{NTranslateBits=15;}}else{if(bGroupMixNum>>>13){NTranslateBits=14;}else{NTranslateBits=13;}}}else{if(bGroupMixNum>>>10){if(bGroupMixNum>>>11){NTranslateBits=12;}else{NTranslateBits=11;}}else{if(bGroupMixNum>>>9){NTranslateBits=10;}else{NTranslateBits=9;}}}}else{if(bGroupMixNum>>>4){if(bGroupMixNum>>>6){if(bGroupMixNum>>>7){NTranslateBits=8;}else{NTranslateBits=7;}}else{if(bGroupMixNum>>>5){NTranslateBits=6;}else{NTranslateBits=5;}}}else{if(bGroupMixNum>>>2){if(bGroupMixNum>>>3){NTranslateBits=4;}else{NTranslateBits=3;}}else{if(bGroupMixNum>>>1){NTranslateBits=2;}else{NTranslateBits=bGroupMixNum;}}}}}
			
			bGroupValue|=NTranslateBits<<(32-(bGroupBitsOffset+=5));
			
			//向 data 写入满8位(1字节)的数据:
			if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
			
			bGroupRshiftBitsOffset=32-NTranslateBits;
			bGroupValue|=(TranslateX<<bGroupRshiftBitsOffset)>>>bGroupBitsOffset;
			bGroupBitsOffset+=NTranslateBits;
			
			//向 data 写入满8位(1字节)的数据:
			if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
			
			bGroupValue|=(TranslateY<<bGroupRshiftBitsOffset)>>>bGroupBitsOffset;
			bGroupBitsOffset+=NTranslateBits;
			
			//向 data 写入有效的数据:
			if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;data[offset++]=bGroupValue;}else{data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;}}else if(bGroupBitsOffset>8){data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;}else{data[offset++]=bGroupValue>>24;}
			return data;
		}

		public function toXML(xmlName:String,_toXMLOptions:Object):XML{
			var xml:XML=<{xmlName} class="edgarcai.swf.records.MATRIX"/>;
			if(HasScale){
				xml.@HasScale=HasScale;
				xml.@ScaleX=ScaleX;
				xml.@ScaleY=ScaleY;
			}
			if(HasRotate){
				xml.@HasRotate=HasRotate;
				xml.@RotateSkew0=RotateSkew0;
				xml.@RotateSkew1=RotateSkew1;
			}
			xml.@TranslateX=TranslateX;
			xml.@TranslateY=TranslateY;
			return xml;
		}
		public function initByXML(xml:XML,_initByXMLOptions:Object):void{
			HasScale=(xml.@HasScale.toString()=="true");
			if(HasScale){
				ScaleX=int(xml.@ScaleX.toString());
				ScaleY=int(xml.@ScaleY.toString());
			}
			HasRotate=(xml.@HasRotate.toString()=="true");
			if(HasRotate){
				RotateSkew0=int(xml.@RotateSkew0.toString());
				RotateSkew1=int(xml.@RotateSkew1.toString());
			}
			TranslateX=int(xml.@TranslateX.toString());
			TranslateY=int(xml.@TranslateY.toString());
		}
	}
}
