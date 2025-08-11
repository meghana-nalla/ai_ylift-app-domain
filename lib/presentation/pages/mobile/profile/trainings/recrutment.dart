import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class PendingInvitation {
  final String id;
  final int profileId;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;

  PendingInvitation({
    required this.id,
    required this.profileId,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PendingInvitation.fromJson(Map<String, dynamic> json) {
    return PendingInvitation(
      id: json['id'],
      profileId: json['profileId'],
      email: json['email'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profileId': profileId,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class InvitedUser {
  final String name;
  final String email;

  InvitedUser({required this.name, required this.email});
}

class RecruitmentWidget extends StatefulWidget {
  final List<PendingInvitation> pendingInvitations;

  RecruitmentWidget({Key? key, required this.pendingInvitations})
      : super(key: key);

  @override
  _RecruitmentWidgetState createState() => _RecruitmentWidgetState();
}

class _RecruitmentWidgetState extends State<RecruitmentWidget> {
  bool _isExpanded = false;
  String email = "";
  bool working = false;
  String? error;
  List<InvitedUser> invited = [];
  int invitedCount = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadInvitedList();
  }

  Future<void> loadInvitedList() async {
    // TODO: Replace this with actual API call
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      invited = [
        InvitedUser(name: "John Doe", email: "john@example.com"),
        InvitedUser(name: "Jane Smith", email: "jane@example.com"),
      ];
      invitedCount = invited.length;
    });
  }

  Future<void> send() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        working = true;
        error = null;
      });

      try {
        // TODO: Replace this with actual API call
        await Future.delayed(Duration(seconds: 2));

        // Fluttertoast.showToast(
        //   msg: "Invitation link was sent to $email",
        //   toastLength: Toast.LENGTH_LONG,
        //   gravity: ToastGravity.BOTTOM,
        //   backgroundColor: Colors.green,
        //   textColor: Colors.white,
        // );

        setState(() {
          email = "";
        });
      } catch (e) {
        setState(() {
          error =
              "Unable to send invitation to this email, perhaps profile with the same email is already registered.";
        });
      } finally {
        setState(() {
          working = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('Recruitment'),
            trailing: TextButton(
              child: Text(_isExpanded ? 'Collapse' : 'Expand'),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
            subtitle: Text('You have invited $invitedCount user(s).'),
          ),
          if (_isExpanded) ...[
            Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        helperText:
                            'Invitation link will be sent to this email.',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                    if (error != null)
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child:
                            Text(error!, style: TextStyle(color: Colors.red)),
                      ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: working ? null : send,
                      child: working
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : Text('Send Invite'),
                    ),
                    if (invited.isNotEmpty) ...[
                      SizedBox(height: 16),
                      Text('The list of users accepted invitation:'),
                      ...invited.map((user) => ListTile(
                            title: Text(user.name),
                            subtitle: Text(user.email),
                          )),
                    ],
                    if (widget.pendingInvitations.isNotEmpty) ...[
                      SizedBox(height: 16),
                      Text('Pending invitations:'),
                      ...widget.pendingInvitations.map((invitation) => ListTile(
                            title: Text(invitation.email),
                            subtitle: Text(
                                'Sent: ${DateFormat('yyyy-MM-dd HH:mm').format(invitation.createdAt)}'),
                          )),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
