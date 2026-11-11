sealed class Countdown {
  const Countdown();
}

class Upcoming extends Countdown {
  final Duration remaining;

  const Upcoming(this.remaining);
}

class Started extends Countdown {
  final Duration elapsed;

  const Started(this.elapsed);
}

class Ended extends Countdown {
  const Ended();
}

Countdown getCountdown(DateTime start, DateTime end) {
  final now = DateTime.now();

  if (now.isBefore(start)) {
    return Upcoming(start.difference(now));
  }

  if (now.isBefore(end)) {
    return Started(now.difference(start));
  }

  return const Ended();
}
