#-- encoding: UTF-8
#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2013 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++
require File.expand_path('../../../test_helper', __FILE__)

class TimelogHelperTest < HelperTestCase
  include TimelogHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::DateHelper

  def test_activities_collection_for_select_options_should_return_array_of_activity_names_and_ids
    design = TimeEntryActivity.find_by_name("Design") || FactoryGirl.create(:activity, :name => "Design")
    development = TimeEntryActivity.find_by_name("Development") || FactoryGirl.create(:activity, :name => "Development")
    activities = activity_collection_for_select_options
    assert activities.include?(["Design", design.id])
    assert activities.include?(["Development", development.id])
  end

  def test_activities_collection_for_select_options_should_not_include_inactive_activities
    inactive = TimeEntryActivity.find_by_name("Inactive Activity") || FactoryGirl.create(:inactive_activity, :name => "Inactive Activity")
    activities = activity_collection_for_select_options
    assert !activities.include?(["Inactive Activity", inactive.id])
  end

  def test_activities_collection_for_select_options_should_use_the_projects_override
    project = FactoryGirl.create :valid_project
    design = TimeEntryActivity.find_by_name("Design") || FactoryGirl.create(:activity, :name => "Design")
    override_activity = TimeEntryActivity.create!({:name => "Design override", :parent => TimeEntryActivity.find_by_name("Design"), :project => project})

    activities = activity_collection_for_select_options(nil, project)
    assert !activities.include?(["Design", design.id]), "System activity found in: " + activities.inspect
    assert activities.include?(["Design override", override_activity.id]), "Override activity not found in: " + activities.inspect
  end
end
