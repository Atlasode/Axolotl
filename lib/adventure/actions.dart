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

  AdventureUpdateTask(this.index, this.task);
}

class AdventureAddTask extends AdventureAction {
  final AdventureTask task;

  const AdventureAddTask(this.task);
}

class AdventureClose extends AdventureAction{

  AdventureClose();
}

class AdventureOpen extends AdventureAction{
  final Adventure adventure;
  final int index;
  final AdventureSettings settings;

  AdventureOpen(this.adventure, this.index, {this.settings = AdventureSettings.EASY});
}