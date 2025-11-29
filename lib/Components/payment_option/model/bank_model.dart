class BankDetails {
  final int id;
  final String bankName;
  final String accountNumber;
  final String accountHolderName;
  final String bankBranch;
  final String ifscCode;
  final String upiId;
  final String upiQrCode;

  BankDetails({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolderName,
    required this.bankBranch,
    required this.ifscCode,
    required this.upiId,
    required this.upiQrCode,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) {
    return BankDetails(
      id: json['id'],
      bankName: json['bank_name'] ?? "",
      accountNumber: json['account_number'] ?? "",
      accountHolderName: json['account_holder_name'] ?? "",
      bankBranch: json['bank_branch'] ?? "",
      ifscCode: json['ifsc_code'] ?? "",
      upiId: json['upi_id'] ?? "",
      upiQrCode: json['upi_qr_code'] ?? "",
    );
  }
}
