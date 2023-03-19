import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/dialogs/delete_reminder.dart';
import 'package:sample/dialogs/show_text.dart';
import 'package:sample/screens/main_pop_up.dart';
import 'package:sample/state/app_state.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        actions: [
          IconButton(
              onPressed: () async{
                final reminderText = await showTextFieldDialog(
                    context: context, 
                    title: 'What would you like to remember', 
                    hintText: 'Enter your to do here', 
                    optionsBuilder: () => {
                      TextFieldDialogButtonType.cancel: 'cancel',
                      TextFieldDialogButtonType.confirm: 'save',
                    });
                if(reminderText==null){
                  return;
                }
                context.read<AppState>().createReminder(reminderText);
              }, 
              icon: const Icon(Icons.add),
          ),
          const MainPopUpMenuButton(),
        ],
      ),
      body: const RemindersListView(),
    );
  }
}
class RemindersListView extends StatelessWidget {
  const RemindersListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Observer(builder: (context){
      return ListView.builder(
          itemCount: appState.sortedReminders.length,
          itemBuilder: (context, index){
            final reminder = appState.sortedReminders[index];
            return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: reminder.isDone,
              onChanged: (isDone){
                context.read<AppState>().modify(
                    reminder,
                    isDone: isDone ?? false,
                );
                reminder.isDone = isDone ?? false;
              },
              title: Row(
                children: [
                  Expanded(
                      child: Text(
                        reminder.text,
                      ),
                  ),
                  IconButton(
                      onPressed: () async{
                        final shouldDeleteReminder =
                            await showDeleteReminderDialog(context);
                        if (shouldDeleteReminder) {
                          context.read<AppState>().delete(reminder);
                        }
                      },
                      icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            );
          });
    });
  }
}

