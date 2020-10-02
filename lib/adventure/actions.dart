import 'package:axolotl/adventure/states.dart';
import 'package:axolotl/common/app_state.dart';

class AdventureAction {
  const AdventureAction();
}


class AdventureUpdateInstance extends AdventureAction {
  final Adventure instance;

  AdventureUpdateInstance(this.instance);
}

class AdventureUpdateIndex extends AdventureAction {
  final int index;

  AdventureUpdateIndex(this.index);
}

class AdventureValidate extends AdventureAction {
  final bool all;

  AdventureValidate(this.all);

}

// Generally the same as UpdateIndex but only move forwards or backwards
class AdventureMovePage {
  final bool next;

  AdventureMovePage(this.next);
}

class AdventureUpdateSettings extends AdventureAction {
  final AdventureSettings settings;

  AdventureUpdateSettings(this.settings);
}

class AdventureUpdateField extends AdventureAction {
  final dynamic value;
  final int taskIndex;
  final int fieldIndex;

  AdventureUpdateField(this.value, this.fieldIndex, {this.taskIndex});
}

class AdventureUpdateTaskState extends AdventureAction {
  final TaskDifference diff;
  final List<dynamic> values;
  final int index;

  AdventureUpdateTaskState(this.diff, this.values, this.index);

}

class AdventureRemoveTask extends AdventureAction {
  final int index;

  const AdventureRemoveTask(this.index);
}

class AdventureUpdateTask extends AdventureAction {
  final int index;
  final AdventureTask task;
  final AdventureTaskData taskData;

  AdventureUpdateTask(this.index, this.task, this.taskData);
}

class AdventureAddTask extends AdventureAction {
  final AdventureTask task;
  final AdventureTaskData taskData;

  const AdventureAddTask(this.task, this.taskData);
}

class AdventureClose extends AdventureAction{

  AdventureClose();
}

class AdventureOpen extends AdventureAction{
  final Adventure adventure;
  final List<AdventureTask> tasks;
  final int index;
  final AdventureSettings settings;

  AdventureOpen(this.adventure, this.tasks, this.index, {this.settings});
}

Future<void> openAdventure(
    Adventure adventure,
    int index,
    {AdventureSettings settings = AdventureSettings.EASY})
async {
  List<AdventureTask> tasks = await Future.wait(adventure.taskData.map((e) => e.createTask()));
  Redux.dispatch(AdventureOpen(adventure, tasks, index, settings: settings));
}