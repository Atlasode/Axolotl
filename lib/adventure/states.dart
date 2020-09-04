class AdventureState {


  const AdventureState();
}

enum TaskType {
  VERB_COLLECTION,
  VOCABULARY_LIST,
}

class TaskList {

}

class AdventureTask {
  final TaskType type;
  final String name;

  const AdventureTask(this.type, this.name);
}