Nurb.run do
  observable = Rx::Observable.new { |obs|
    i = 0
    interval = Nurb.set_interval(10) {
      obs.next(i)
      i += 1
      if i == 5
        Nurb.clear_interval(interval)
        obs.complete
      end
    }
  }

  observable.subscribe(
    next: proc { |val| puts "Got #{val}" },
    complete: proc { puts "DONE!" }
  )
end
