//RECT
//Field 		Type 		Comment
//Nbits 		UB[5] 		Bits used for each subsequent field
//Xmin 			SB[Nbits] 	x minimum position for rectangle in twips
//Xmax 			SB[Nbits] 	x maximum position for rectangle in twips
//Ymin 			SB[Nbits] 	y minimum position for rectangle in twips
//Ymax 			SB[Nbits] 	y maximum position for rectangle in twips
package edgarcai.swf.records{
	import flash.utils.ByteArray;
	public class RECT{
		public var Xmin:int;
		public var Xmax:int;
		public var Ymin:int;
		public var Ymax:int;
		//
		public function initByData(data:ByteArray,offset:int,endOffset:int,_initByDataOptions:Object):int{
			var bGroupValue:int=(data[offset++]<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];
			var Nbits:int=bGroupValue>>>27;							//11111000 00000000 00000000 00000000
			var bGroupBitsOffset:int=5;
			
			
			if(Nbits){
				var bGroupRshiftBitsOffset:int=32-Nbits;
				var bGroupNegMask:int=1<<(Nbits-1);
				var bGroupNeg:int=0xffffffff<<Nbits;
				
				Xmin=(bGroupValue<<5)>>>bGroupRshiftBitsOffset;
				if(Xmin&bGroupNegMask){Xmin|=bGroupNeg;}//最高位为1,表示负数
				bGroupBitsOffset+=Nbits;
				
				//从 data 读取足够多的位数以备下面使用:
				if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
				
				Xmax=(bGroupValue<<bGroupBitsOffset)>>>bGroupRshiftBitsOffset;
				if(Xmax&bGroupNegMask){Xmax|=bGroupNeg;}//最高位为1,表示负数
				bGroupBitsOffset+=Nbits;
				
				//从 data 读取足够多的位数以备下面使用:
				if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
				
				Ymin=(bGroupValue<<bGroupBitsOffset)>>>bGroupRshiftBitsOffset;
				if(Ymin&bGroupNegMask){Ymin|=bGroupNeg;}//最高位为1,表示负数
				bGroupBitsOffset+=Nbits;
				
				//从 data 读取足够多的位数以备下面使用:
				if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
				
				Ymax=(bGroupValue<<bGroupBitsOffset)>>>bGroupRshiftBitsOffset;
				if(Ymax&bGroupNegMask){Ymax|=bGroupNeg;}//最高位为1,表示负数
				bGroupBitsOffset+=Nbits;
			}
			
			return offset-int(4-bGroupBitsOffset/8);
		}
		public function toData(_toDataOptions:Object):ByteArray{
			var data:ByteArray=new ByteArray();
			var bGroupValue:int=0;
			var offset:int=0;
			
			//计算所需最小位数:
			var bGroupMixNum:int=((Xmin<0?-Xmin:Xmin)<<1)|((Xmax<0?-Xmax:Xmax)<<1)|((Ymin<0?-Ymin:Ymin)<<1)|((Ymax<0?-Ymax:Ymax)<<1);
			if(bGroupMixNum>>>16){if(bGroupMixNum>>>24){if(bGroupMixNum>>>28){if(bGroupMixNum>>>30){if(bGroupMixNum>>>31){var Nbits:int=32;}else{Nbits=31;}}else{if(bGroupMixNum>>>29){Nbits=30;}else{Nbits=29;}}}else{if(bGroupMixNum>>>26){if(bGroupMixNum>>>27){Nbits=28;}else{Nbits=27;}}else{if(bGroupMixNum>>>25){Nbits=26;}else{Nbits=25;}}}}else{if(bGroupMixNum>>>20){if(bGroupMixNum>>>22){if(bGroupMixNum>>>23){Nbits=24;}else{Nbits=23;}}else{if(bGroupMixNum>>>21){Nbits=22;}else{Nbits=21;}}}else{if(bGroupMixNum>>>18){if(bGroupMixNum>>>19){Nbits=20;}else{Nbits=19;}}else{if(bGroupMixNum>>>17){Nbits=18;}else{Nbits=17;}}}}}else{if(bGroupMixNum>>>8){if(bGroupMixNum>>>12){if(bGroupMixNum>>>14){if(bGroupMixNum>>>15){Nbits=16;}else{Nbits=15;}}else{if(bGroupMixNum>>>13){Nbits=14;}else{Nbits=13;}}}else{if(bGroupMixNum>>>10){if(bGroupMixNum>>>11){Nbits=12;}else{Nbits=11;}}else{if(bGroupMixNum>>>9){Nbits=10;}else{Nbits=9;}}}}else{if(bGroupMixNum>>>4){if(bGroupMixNum>>>6){if(bGroupMixNum>>>7){Nbits=8;}else{Nbits=7;}}else{if(bGroupMixNum>>>5){Nbits=6;}else{Nbits=5;}}}else{if(bGroupMixNum>>>2){if(bGroupMixNum>>>3){Nbits=4;}else{Nbits=3;}}else{if(bGroupMixNum>>>1){Nbits=2;}else{Nbits=bGroupMixNum;}}}}}
			
			bGroupValue|=Nbits<<27;							//11111000 00000000 00000000 00000000
			var bGroupBitsOffset:int=5;
			
			var bGroupRshiftBitsOffset:int=32-Nbits;
			bGroupValue|=(Xmin<<bGroupRshiftBitsOffset)>>>5;
			bGroupBitsOffset+=Nbits;
			
			//向 data 写入满8位(1字节)的数据:
			if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
			
			bGroupValue|=(Xmax<<bGroupRshiftBitsOffset)>>>bGroupBitsOffset;
			bGroupBitsOffset+=Nbits;
			
			//向 data 写入满8位(1字节)的数据:
			if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
			
			bGroupValue|=(Ymin<<bGroupRshiftBitsOffset)>>>bGroupBitsOffset;
			bGroupBitsOffset+=Nbits;
			
			//向 data 写入满8位(1字节)的数据:
			if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){bGroupBitsOffset-=24;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;bGroupValue<<=24;}else{bGroupBitsOffset-=16;data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;bGroupValue<<=16;}}else if(bGroupBitsOffset>8){bGroupBitsOffset-=8;data[offset++]=bGroupValue>>24;bGroupValue<<=8;}
			
			bGroupValue|=(Ymax<<bGroupRshiftBitsOffset)>>>bGroupBitsOffset;
			bGroupBitsOffset+=Nbits;
			
			//向 data 写入有效的数据:
			if(bGroupBitsOffset>16){if(bGroupBitsOffset>24){data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;data[offset++]=bGroupValue;}else{data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;data[offset++]=bGroupValue>>8;}}else if(bGroupBitsOffset>8){data[offset++]=bGroupValue>>24;data[offset++]=bGroupValue>>16;}else{data[offset++]=bGroupValue>>24;}
			return data;
		}
		
		public function toXML(xmlName:String,_toXMLOptions:Object):XML{
			return <{xmlName} class="edgarcai.swf.records.RECT"
				Xmin={Xmin}
			Xmax={Xmax}
			Ymin={Ymin}
			Ymax={Ymax}
			/>;
		}
		public function initByXML(xml:XML,_initByXMLOptions:Object):void{
			Xmin=int(xml.@Xmin.toString());
			Xmax=int(xml.@Xmax.toString());
			Ymin=int(xml.@Ymin.toString());
			Ymax=int(xml.@Ymax.toString());
		}
	}
}
