import 'package:mobile/communication/pojos/PojoGrade.dart';
import 'package:mobile/extension_methods/round_double_extension.dart';

double calculateGradeAverage(List<PojoGrade> pojoGrades){
	double gradeAmount = 0;
	double gradeSum = 0;
	for(PojoGrade pojoGrade in pojoGrades){
		if(pojoGrade != null && pojoGrade.grade != null && pojoGrade.weight != null){
			try {
				int grade = int.parse(pojoGrade.grade);
				int weight = pojoGrade.weight;

				if(grade != null) {
					double gradeWeightCurrent = weight / 100;
					gradeAmount += gradeWeightCurrent;
					gradeSum += gradeWeightCurrent * grade;
				}
			}catch(e){

			}
		}
	}
	if(gradeSum != 0 && gradeAmount != 0){
		return (gradeSum/gradeAmount).round2(decimals: 2);
	}
	return 0;
}