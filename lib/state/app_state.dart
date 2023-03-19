import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:sample/auth/auth_error.dart';
import 'package:sample/state/reminder.dart';
import 'package:firebase_auth/firebase_auth.dart';


part 'app_state.g.dart';

class AppState = _AppState with _$AppState;

abstract class _AppState with Store{
  //observable for the current screen i.e the login screen which will appear first
  @observable
  AppScreen currentScreen = AppScreen.login;

  //observable for loading screen
  @observable
  bool isLoading = false;

  //observable that keeps track of the current user
  @observable
  User? currentUser;

  //observable that holds on to the various auth errors
  @observable
  AuthError? authError;

  //looks at the list of reminders
  @observable
  ObservableList<Reminder> reminders = ObservableList<Reminder>();

  //looks at the sorted list of reminders
  @computed
  ObservableList<Reminder> get sortedReminders =>
      ObservableList.of(reminders.sorted());

  //action for moving to screens
  @action
  void goTo(AppScreen screen){
    currentScreen =screen;
  }

  //function for deleting reminders
  @action
  Future<bool> delete(Reminder reminder) async {
    isLoading = true;
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user == null){
      isLoading = false;
      return false;
    }
    final userId = user.uid;
    final collection = await FirebaseFirestore.instance
      .collection(userId)
      .get();
    try{
      //removing reminder from firebase
      final firebaseReminder = collection.docs.firstWhere(
              (element) => element.id == reminder.id,
      );
      await firebaseReminder.reference.delete();
      // removing from local storage
      reminders.removeWhere(
              (element) => element.id == reminder.id,
      );
      return true;
    }catch(_){
      return false;
    } finally {
      isLoading = false;
    }
  }

  //deleting an account
  @action
  Future<bool> deleteAccount() async {
    isLoading = true;
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user == null) {
      isLoading =  false;
      return false;
    }
    final userId=user.uid;
    try{
      final store= FirebaseFirestore.instance;
      final operation = store.batch();
      final collection = await store.collection(userId).get();
      for (final document in collection.docs) {
        operation.delete(document.reference);
      }
      //deleting all users reminders
      await operation.commit();
      //deleting user
      await user.delete();
      //log out user after deletion
      await auth.signOut();
      // set current screen
      currentScreen = AppScreen.login;
      return true;
    } on FirebaseAuthException catch(e){
      authError = AuthError.from(e);
      return false;
    }catch (_){
      return false;
    }finally{
      isLoading = false;
    }
  }

  //function to logout user
  @action
  Future<void> logOut() async {
    isLoading = true;
    try{
      await FirebaseAuth.instance.signOut();
    }catch(_){
      //ignore any errors
    }
    isLoading = false;
    currentScreen = AppScreen.login;
    reminders.clear();
  }

  //function to create reminders
  @action
  Future<bool> createReminder(String text) async{
    isLoading = true;
    final userId = currentUser?.uid;
    if (userId == null){
      isLoading = false;
      return false;
    }
    final dateCreated = DateTime.now();
    // creating reminder on firebase
    final firebaseReminder = await FirebaseFirestore
      .instance
      .collection(userId)
      .add(
      {
        _DocumentKeys.text:text,
        _DocumentKeys.dateCreated: dateCreated,
        _DocumentKeys.isDone: false,
    });

    //creating reminder locally
    final reminder = Reminder(
        id: firebaseReminder.id,
        text: text,
        isDone: false,
        dateCreated: dateCreated,
    );
    reminders.add(reminder);
    isLoading = false;
    return true;
  }

  //updating reminder
  @action
  Future<bool> modify(
      Reminder reminder, {
        required bool isDone,
      }) async{
          final userId = currentUser?.uid;
          if (userId == null){
            return false;
          }

          //updating reminder to firebase
          final collection = await FirebaseFirestore
            .instance
            .collection(userId)
            .get();
          final firebaseReminder = collection.docs
            .where((element) => element.id == reminder.id)
            .first
            .reference;
          await firebaseReminder.update({
            _DocumentKeys.isDone: isDone
          });

          //updating reminder locally
          reminders.firstWhere(
                  (element) => element.id == reminder.id,
          )
          .isDone = isDone;
          return true;
  }

  //function to initialize the application state i.e if user was logged on it doesn't take them back to login screen
  @action
  Future<void> initialize() async{
    isLoading = true;
    currentUser = FirebaseAuth.instance.currentUser;
    if(currentUser != null){
      _loadReminders;
      currentScreen = AppScreen.reminders;
    }else{
      currentScreen = AppScreen.login;
    }
    isLoading = false;
  }

  //function  to load reminders
  @action
  Future<bool> _loadReminders() async{
    final userId = currentUser?.uid;
    if (userId == null){
      return false;
    }
    final collection = await FirebaseFirestore
      .instance
      .collection(userId)
      .get();
    final reminders = collection.docs.map(
            (doc) => Reminder(
                id: doc.id,
                text: doc[_DocumentKeys.text] as String,
                isDone: doc[_DocumentKeys.isDone] as bool,
                dateCreated: DateTime.parse(doc[_DocumentKeys.dateCreated] as String),
            ),
    );
    this.reminders = ObservableList.of(reminders);
    return true;
  }

  //login and register function
  @action
  Future<bool> _registerOrLogin({
    required LoginOrRegisterFunction fn,
    required String email,
    required String password,
    }) async{
      authError = null;
      isLoading = true;
      try{
        await fn(
          email: email,
          password: password,
        );
        currentUser = FirebaseAuth.instance.currentUser;
        await _loadReminders();
        return true;
      } on FirebaseAuthException catch(e){
        authError = AuthError.from(e);
        print(e);
        return false;
      } finally {
        isLoading =false;
        if (currentUser != null){
          currentScreen = AppScreen.reminders;
        }
      }
  }

  //function to implement register user
  @action
  Future<bool> register({
    required String email,
    required String password,
  }) =>
      _registerOrLogin(
          fn: FirebaseAuth.instance.createUserWithEmailAndPassword,
          email: email,
          password: password
      );

  //function implementing log in
  @action
  Future<bool> login({
    required String email,
    required String password,
  }) =>
      _registerOrLogin(
          fn: FirebaseAuth.instance.signInWithEmailAndPassword,
          email: email,
          password: password
      );



}
abstract class _DocumentKeys {
  static const text = 'text';
  static const dateCreated = 'date_created';
  static const isDone = 'is_done';
}

typedef LoginOrRegisterFunction = Future<UserCredential> Function({
  required String email,
  required String password,
});

//convert bool to integer
extension ToInt on bool{
  int toInteger() => this ? 1:0;
}

//sort function for reminders
extension Sorted on List<Reminder>{
  List<Reminder> sorted() => [...this]..sort((lhs, rhs){
    final isDone = lhs.isDone.toInteger().compareTo(rhs.isDone.toInteger());
    if (isDone != 0){
      return isDone;
    }
    return lhs.dateCreated.compareTo(rhs.dateCreated);
  });
}
//defining the different application screens
enum AppScreen {login, register, reminders}