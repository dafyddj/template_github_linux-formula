# frozen_string_literal: true

# system.rb -- InSpec resources for system values
# Author: Daniel Dehennin <daniel.dehennin@ac-dijon.fr>
# Copyright (C) 2020 Daniel Dehennin <daniel.dehennin@ac-dijon.fr>

class SystemResource < Inspec.resource(1)
  name 'system'

  attr_reader :platform

  def initialize
    @platform = build_platform
  end

  private

  def build_platform
    {
      family: build_platform_family,
      name: build_platform_name,
      release: build_platform_release,
      finger: build_platform_finger
    }
  end

  def build_platform_family
    case inspec.platform[:name]
    when 'arch'
      'arch'
    else
      inspec.platform[:family]
    end
  end

  def build_platform_name
    case inspec.platform[:name]
    when 'amazon'
      'amazonlinux'
    else
      inspec.platform[:name]
    end
  end

  def build_platform_release
    case inspec.platform[:name]
    when 'amazon'
      # `2018` relase is named `1` in kitchen.yaml
      inspec.platform[:release].gsub(/2018.*/, '1')
    when 'arch'
      'base-latest'
    else
      inspec.platform[:release]
    end
  end

  def build_platform_finger
    "#{build_platform_name}-#{build_finger_release}"
  end

  def build_finger_release
    case inspec.platform[:name]
    when 'ubuntu'
      build_platform_release.split('.').slice(0, 2).join('.')
    else
      build_platform_release.split('.')[0]
    end
  end
end
