class UserDTO {
  final String uid;
  final String? email;
  final bool? isManager;
  final String? managerId;
  final String? did;
  final String? lid;
  final String? cid;
  final String? name;

  UserDTO({
    required this.uid,
    this.email,
    this.isManager,
    this.managerId,
    this.did,
    this.lid,
    this.cid,
    this.name,
  });
}
