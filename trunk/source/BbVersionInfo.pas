{*******************************************************************************

  Berimbau VCL

  BbVersionInfo.pas

  Provides version information for BerimbauVCL.

  Copyright (C) 2009 Walber Zaldivar <walber.zaldivar@gmail.com>

********************************************************************************

  This library is free software: you can redistribute it and/or modify
  it under the terms of the GNU Lesser General Public License as published
  by the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.

*******************************************************************************}

unit BbVersionInfo;

interface

const
  // Version numbers
  BB_VERSION_MAJOR   = 0; // 0 = pre-release|beta / 1,2,... = major
  BB_VERSION_MINOR   = 1; // minor version
  BB_VERSION_RELEASE = 0; // 0 = pre-release|beta / 1,2,... = release
  BB_VERSION_BUILD   = 0; // build = update

  // Release date
  BB_RELEASE_DATE = '2009-11-24'; // yyyy-mm-dd format

  // Version status
  BB_STATUS = 'pre-release'; // pre-release|beta|stable

  // Short version string
  BB_SHORT_VERSION_STRING = '0.1'; // major.minor

  // Long/Full version string
  BB_LONG_VERSION_STRING = '0.1.0.0'; // major.minor.release.build

  // Berimbau VCL web-site
  BB_WEB_SITE = 'http://berimbauvcl.sourceforge.net';

  // Berimbau VCL mail-list
  BB_MAIL_LIST = 'berimbauvcl-users@lists.sourceforge.net';

type
  // Version information dummy type
  TBbVersionInfo = (BbVersion);

implementation

end.
