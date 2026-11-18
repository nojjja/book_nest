// data/result.dart — вердикт: товар или сообщение для экрана (C8)
sealed class Result<T> {
  const Result();
}

class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);
}

class Err<T> extends Result<T> {
  final String msg;
  const Err(this.msg);
}
