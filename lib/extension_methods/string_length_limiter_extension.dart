extension StringLengthLimiterExtension on String{
	String limit(int maxLength){
		if(this.length > maxLength){
			return this.substring(0, maxLength-1);
		}
		return this;
	}
}