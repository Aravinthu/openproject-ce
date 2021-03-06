#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2015 the OpenProject Foundation (OPF)
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

require 'support/pages/page'

module Pages
  class WorkPackagesTable < Page

    attr_reader :project

    def initialize(project = nil)
      @project = project
    end

    def expect_work_package_listed(work_package)
      within(table_container) do
        expect(page).to have_content(work_package.subject)
      end
    end

    def open_split_view(work_package)
      split_page = SplitWorkPackage.new(work_package, project)

      loading_indicator_saveguard
      page.driver.browser.mouse.double_click(row(work_package).native)

      split_page
    end

    def open_full_screen(work_package)
      visit row(work_package).find_link(work_package.subject)[:href]

      FullWorkPackage.new(work_package)
    end

    private

    def path
      project ? project_work_packages_path(project) : work_packages_path
    end

    def table_container
      find('#content .work-package-table--container')
    end

    def row(work_package)
      table_container.find("#work-package-#{work_package.id}")
    end
  end
end
