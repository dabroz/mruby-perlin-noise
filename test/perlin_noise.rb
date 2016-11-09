# encoding: utf-8

assert('test_gradient_table') do
  [10, 100, 1000].each do |interval|

    gt = Perlin::GradientTable.new 1, interval

    interval.times do |i|
      assert_true (0.99..1.01).include?(gt[interval + i].r)
    end

    assert_equal gt[1], gt[1 + interval]
    assert_equal gt[1], gt[1 + interval * 2]

    gt = Perlin::GradientTable.new 2, interval
    assert_equal gt[1, 1], gt[1, 1 + interval]
    assert_equal gt[1, 1], gt[1, 1 + interval * 2]

    gt = Perlin::GradientTable.new 4, interval
    assert_equal gt[1, 2, 3, 4], gt[1, 2, 3 + interval, 4]
    assert_equal gt[1, 2, 3, 4], gt[1, 2, 3 + interval * 2, 4]

    interval.times do |i|
      # FIXME: rand
      assert_true (0.99..1.01).include?(gt[rand(interval), rand(interval), rand(interval), interval + i].r)
    end
  end
end

assert('test_curve') do
  curves = [ Perlin::Curve::LINEAR, Perlin::Curve::CUBIC, Perlin::Curve::QUINTIC ]

  curves.each_with_index do |c, idx|
    0.step(1, 0.01).each do |x|
      case idx
      when 0
        assert_equal x, c.call(x)
      else
        if x == 1 || x == 0
          assert_equal x, c.call(x)
        elsif x > 0.5
          assert_true c.call(x) > x
        elsif x == 0.5
          assert_equal x, c.call(x)
        else
          assert_true c.call(x) < x
        end
      end
    end
  end
end

assert('test_noise_invalid_params') do
  # Dimension
  assert_raise(ArgumentError) { Perlin::Noise.new(0) }
  assert_raise(ArgumentError) { Perlin::Noise.new(0.1) }
  assert_raise(ArgumentError) { Perlin::Noise.new(-1) }
  assert_raise(ArgumentError) { Perlin::Noise.new(-0.1) }

  # Interval
  Perlin::Noise.new 1
  Perlin::Noise.new 1, :inteval => 100
  assert_raise(ArgumentError) { Perlin::Noise.new 1, :interval => 0.5 }
  assert_raise(ArgumentError) { Perlin::Noise.new 1, :interval => -1 }

  # Seed
  Perlin::Noise.new 1, :seed => 1
  Perlin::Noise.new 1, :seed => 0.1
  Perlin::Noise.new 1, :seed => -0.1
  assert_raise(ArgumentError) { Perlin::Noise.new 1, :seed => "seed" }

  # Curve
  Perlin::Noise.new 2, :curve => Perlin::Curve::CUBIC
  assert_raise(ArgumentError) { Perlin::Noise.new 2, :curve => nil }
end

assert('test_noise_1d') do
  width = 60

  noise = Perlin::Noise.new 1, :interval => 200
  0.step(300, 0.1).each do |x|
    n = noise[x]
    len = (n * width).to_i
    #puts '#' * len
    assert_true (0..width).include?(len)

    if x.to_i == x
      assert_equal 0.5, noise[x]
    end
  end
end

assert('test_noise_range') do
  (1..7).each do |dim|
    noise = Perlin::Noise.new dim
    max = -999
    min =  999

    (0..100).each do |i|
      coords = Array.new(dim) { |j| i * (j + 1) * 0.001 }
      n = noise[*coords]

      assert_true (0..1).include?(n)

      max = n if n > max
      min = n if n < min
    end
  end
end


assert('test_noise_2d') do
  noises = Perlin::Noise.new(2)
  contrast = Perlin::Curve.contrast(Perlin::Curve::CUBIC, 2)

  #bars = " ▁▂▃▄▅▆▇█".each_char.to_a
  #bar = lambda { |n|
  #  bars[ (bars.length * n).floor ]
  #}

  100.times do |i|
    70.times do |y|
      n = noises[i * 0.1, y * 0.1]
      n = contrast.call n

      #print bar.call(n)
    end
    #puts
  end
end

assert('test_seed') do
  noise1 = Perlin::Noise.new(1, :seed => 12345)
  noise2 = Perlin::Noise.new(1, :seed => 12345)
  assert_equal 0.step(1, 0.01).map { |v| noise1[v] },
    0.step(1, 0.01).map { |v| noise2[v] }

  noise3 = Perlin::Noise.new(1, :seed => 54322)
  assert_not_equal 0.step(1, 0.01).map { |v| noise1[v] },
    0.step(1, 0.01).map { |v| noise3[v] }
end

assert('test_synthesis') do
  noises = Perlin::Noise.new(2, :seed => 0.12345)
  contrast = Perlin::Curve.contrast(Perlin::Curve::QUINTIC, 3)

  100.times do |x|
    n = 0
    [[0.02, 10], [0.04, 10], [0.1, 30], [0.2, 15]].each_with_index do |step_scale, idx|
      step, scale = step_scale
      n += contrast.call( noises[idx, x * step] ) * scale
    end
    #puts '=' * n.floor
  end
end
