import 'dart:io';

import 'package:contacts/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {

	final Contact contact;

	ContactPage({ this.contact });

    @override
    _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

	final _nameController = TextEditingController();
	final _emailController = TextEditingController();
	final _phoneController = TextEditingController();

	final _nameFocus = FocusNode();
	final _phoneFocus = FocusNode();

	bool _edited = false;
	Contact _editedContact;

	@override
	void initState() {
		super.initState();

		if(widget.contact == null) {
			_editedContact = Contact();

		} else {
			_editedContact = Contact.fromMap(widget.contact.toMap());

			_nameController.text = _editedContact.name;
			_emailController.text = _editedContact.email;
			_phoneController.text = _editedContact.phone;		
		}
  	}

    @override
    Widget build(BuildContext context) {
        return Scaffold(
          	appBar: AppBar(
				backgroundColor: Colors.red,
				title: Text(_editedContact.name ?? 'Novo Contato'),
				centerTitle: true,
		  	),
		  	floatingActionButton: FloatingActionButton(
				onPressed: () {
					if((_editedContact.name != null &&_editedContact.name.isNotEmpty) && (_editedContact.phone != null && _editedContact.phone.isNotEmpty)) {
						Navigator.pop(context, _editedContact);

					} else {
						if(_editedContact.name == null || _editedContact.name.isEmpty) {
							FocusScope.of(context).requestFocus(_nameFocus);

						} else {
							FocusScope.of(context).requestFocus(_phoneFocus);
						}
					}
				},
				child: Icon(Icons.save),
				backgroundColor: Colors.red,
		  	),
		  	body: SingleChildScrollView(
				padding: EdgeInsets.all(10.0),
				child: Column(
					children: <Widget>[
						GestureDetector(
							child: Container(
								width: 140.0,
								height: 140.0,
								decoration: BoxDecoration(
									shape: BoxShape.circle,
									image: DecorationImage(
										image: _editedContact.img != null ? FileImage(File(_editedContact.img)) : AssetImage("images/person.png")
									),
								)
							),
						),
						TextField(
							decoration: InputDecoration(labelText: 'Nome'),
							onChanged: (name) {
								_edited = true;
								setState(() {
									_editedContact.name = name;
								});
							},
							controller: _nameController,
							focusNode: _nameFocus,
						),
						TextField(
							decoration: InputDecoration(labelText: 'E-mail'),
							onChanged: (email) {
								_edited = true;
								_editedContact.email = email;
							},
							keyboardType: TextInputType.emailAddress,
							controller: _emailController,
						),
						TextField(
							decoration: InputDecoration(labelText: 'Telefone'),
							onChanged: (phone) {
								_edited = true;
								_editedContact.phone = phone;
							},
							keyboardType: TextInputType.number,
							controller: _phoneController,
							focusNode: _phoneFocus,
						)
					],
				),	  
			), 
        );
    }
}