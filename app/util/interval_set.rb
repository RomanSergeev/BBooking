=begin
class IntervalSet representing set (Array) of intervals (Ranges).
instance variable @intervals always contains array of ranges including end (a..b),
sorted by their begin and not intersecting with each other.
=end

class IntervalSet

  attr_reader :intervals

  # @param [Array<Range>] intervals array of any ranges -
  # they may exclude end, may intersect, may be unordered, but should have integer bounds
  def initialize(intervals)
    if intervals.nil?
      @intervals = nil
      return
    end
    unless intervals.is_a? Array
      raise ArgumentError, 'IntervalSet should be initialized with an array of ranges'
    end
    @intervals = intervals
    remove_bad_intervals
    merge_collided_intervals
  end

  # set1 ^ set2 == X \ ((X\set1) v (X\set2)) where X includes (set1 v set2),
  # ^ == intersection, v == union, \ == difference (exclusion)
  # @param [IntervalSet] set1
  # @param [IntervalSet] set2
  # @return [IntervalSet] intersection
  def self.intersect_sets(set1, set2)
    start = [set1.start, set2.start].min
    finish = [set1.finish, set2.finish].max
    ultimate_set = IntervalSet.new([start..finish])
    ult_copy1 = IntervalSet.new([start..finish])
    ult_copy2 = IntervalSet.new([start..finish])
    ult_copy1.exclude_all!(set1)
    ult_copy2.exclude_all!(set2)
    ultimate_set.exclude_all!(IntervalSet.new(ult_copy1.intervals + ult_copy2.intervals))
    ultimate_set
  end

  # @see app/controllers/services_controller book method
  # method used to construct free_intervals
  # @param [IntervalSet] set1
  # @param [IntervalSet] set2
  # @param [Integer] duration
  # @return [IntervalSet]
  def self.availability_intervals(set1, set2, duration)
    return IntervalSet.new([]) if set1.nil? or set2.nil?
    intersect_sets(set1, set2).cut_from_right!(duration - 1)
  end

  # @return [Integer]
  def start
    @intervals[0].begin
  end

  # @return [Integer]
  def finish
    @intervals[@intervals.length - 1].end
  end

  # excludes _interval from @intervals. Algorithm is as following:
  # @intervals:   [......]      [...]      [.....]
  # _interval:             [..]
  # result:       [......]      [...]      [.....]
  #==============================================
  # @intervals:   [......]      [...]      [.....]
  # _interval:         [....]
  # result:       [...]         [...]      [.....]
  #==============================================
  # @intervals:   [......]      [...]      [.....]
  # _interval:  [.....................]
  # result:                                [.....]
  #==============================================
  # @intervals:   [......]      [...]      [.....]
  # _interval:         [.........]
  # result:       [...]           [.]      [.....]
  #==============================================
  # @intervals:   [......]      [...]      [.....]
  # _interval:  [..................................]
  # result:     (empty Array)
  # @param [Range] _interval
  # @return nil
  def exclude!(_interval)
    interval = make_included_interval(_interval)
    return if
      interval.end <= start or
      interval.begin >= finish or
      interval.begin > interval.end
    if start >= interval.begin and finish <= interval.end
      @intervals.clear
      return
    end
    if @intervals.include?(interval)
      @intervals.delete(interval)
      return
    end
    @intervals.each_with_index do |iter, i|
      start, finish = iter.begin, iter.end
      next if finish < interval.begin or start > interval.end
      if start >= interval.begin and finish <= interval.end
        @intervals[i] = nil
      elsif start <= interval.begin and finish >= interval.end
        @intervals.insert(i + 1, start..(interval.begin - 1))
        @intervals.insert(i + 2, (interval.end + 1)..finish)
        @intervals[i] = nil
      elsif start >= interval.begin
        @intervals[i] = (interval.end + 1)..finish
      elsif finish <= interval.end
        @intervals[i] = start..(interval.begin - 1)
      end
    end
    @intervals.compact!
    remove_bad_intervals
  end

  # excludes all set.intervals from @intervals (result is like a set difference)
  # @see exclude!
  # @param [IntervalSet] set
  # @return nil
  def exclude_all!(set)
    set.intervals.each do |interval|
      exclude!(interval)
    end
  end

  # @param [Integer] amount how much all the ranges from @intervals should be shrank from right
  # @return [IntervalSet] new set without bad/empty ranges
  def cut_from_right(amount)
    intervals = @intervals.clone
    intervals.each_with_index do |interval, i|
      if interval.begin > interval.end - amount
        intervals[i] = nil
      else
        intervals[i] = interval.begin..(interval.end - amount)
      end
    end
    intervals.compact!
    IntervalSet.new(intervals)
  end

  # @param [Integer] amount
  # @return [IntervalSet]
  def cut_from_right!(amount)
    @intervals = cut_from_right(amount).intervals
    itself
  end

  def empty?
    @intervals.nil? or @intervals.length == 0
  end

  def to_s
    @intervals
  end

  private

  # @param [Range] interval of any type
  # @return [Range] range of type a..b
  def make_included_interval(interval)
    return interval unless interval.exclude_end?
    interval.begin..(interval.end - 1)
  end

  # make all ranges in @intervals end-including and remove empty & incorrect ranges
  def remove_bad_intervals
    @intervals.each_with_index do |interval, index|
      included_interval = make_included_interval(interval)
      if included_interval.begin > included_interval.end
        @intervals[index] = nil
      else
        @intervals[index] = included_interval
      end
    end
    @intervals.compact!
  end

  # reorganize initial @intervals to match condition (see top of the file)
  def merge_collided_intervals
    @intervals.sort! { |x,y| x.begin <=> y.begin }
    while (incorrect_index = first_incorrect_index) != -1
      # no need to check min_begin because intervals are already sorted by begin
      max_end = [@intervals[incorrect_index].end, @intervals[incorrect_index + 1].end].max
      @intervals[incorrect_index] =
        @intervals[incorrect_index].begin..max_end
      @intervals.delete_at(incorrect_index + 1)
    end
  end

  # @return [Integer] index of first misplaced interval or -1 if everything is correct
  def first_incorrect_index
    @intervals.each_with_index do |interval, i|
      return -1 if i == @intervals.length - 1
      return i if interval.end >= @intervals[i+1].begin
    end
    -1
  end

end