class Report {
  final String? reportTopic;
  final String reportText;
  final String orderId;

  Report.all(this.reportTopic, this.reportText, this.orderId);

  Map<String, dynamic> toMap() => {
        "reportTopic": reportTopic,
        "reportText": reportText,
        "orderId": orderId,
      };
}
