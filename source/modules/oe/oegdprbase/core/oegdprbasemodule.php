<?php
/**
 * This file is part of OXID eSales GDPR base module.
 *
 * OXID eSales GDPR base module is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * OXID eSales GDPR base module is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with OXID eSales GDPR base module.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @link          http://www.oxid-esales.com
 * @copyright (C) OXID eSales AG 2003-2018
 */

/**
 * Class oeGdprBaseModule
 * Handles module setup, provides additional tools and module related helpers.
 *
 * @codeCoverageIgnore
 */
class oeGdprBaseModule extends oxModule
{
    /**
     * Class constructor.
     * Sets current module main data and loads the rest module info.
     */
    public function __construct()
    {
        $sModuleId = 'oegdprbase';

        $this->setModuleData(
            array(
                'id'          => $sModuleId,
                'title'       => 'OE Gdpr Base',
                'description' => 'OE Gdpr Base Module',
            )
        );

        $this->load($sModuleId);

        oxRegistry::set('oeGdprBaseModule', $this);
    }

    /**
     * Clean temp folder content.
     *
     * @param string $sClearFolderPath Sub-folder path to delete from. Should be a full, valid path inside temp folder.
     *
     * @return boolean
     */
    public static function clearTmp($sClearFolderPath = '')
    {
        $sFolderPath = self::_getFolderToClear($sClearFolderPath);
        $hDirHandler = opendir($sFolderPath);

        if (!empty($hDirHandler)) {
            while (false !== ($sFileName = readdir($hDirHandler))) {
                $sFilePath = $sFolderPath . DIRECTORY_SEPARATOR . $sFileName;
                self::_clear($sFileName, $sFilePath);
            }

            closedir($hDirHandler);
        }

        return true;
    }

    /**
     * Install/uninstall event.
     * Executes SQL queries form a file.
     *
     * @param string $sSqlFile      SQL file located in module docs folder (usually install.sql or uninstall.sql).
     * @param string $sFailureError An error message to show on failure.
     *
     * @return bool
     */
    protected static function _dbEvent($sSqlFile, $sFailureError = 'Operation failed: ')
    {
        try {
            $oDb = oxDb::getDb();
            $sSql = file_get_contents(dirname(__FILE__) . '/../docs/' . (string) $sSqlFile);
            $aSql = (array) explode(';', $sSql);

            foreach ($aSql as $sQuery) {
                if (!empty($sQuery)) {
                    $oDb->execute($sQuery);
                }
            }
        } catch (Exception $ex) {
            error_log($sFailureError . $ex->getMessage());
        }


        self::clearTmp();

        return true;
    }

    /**
     * Check if provided path is inside eShop `tpm/` folder or use the `tmp/` folder path.
     *
     * @param string $sClearFolderPath
     *
     * @return string
     */
    protected static function _getFolderToClear($sClearFolderPath = '')
    {
        $sTempFolderPath = (string) oxRegistry::getConfig()->getConfigParam('sCompileDir');

        if (!empty($sClearFolderPath) and (strpos($sClearFolderPath, $sTempFolderPath) !== false)) {
            $sFolderPath = $sClearFolderPath;
        } else {
            $sFolderPath = $sTempFolderPath;
        }

        return $sFolderPath;
    }

    /**
     * Check if resource could be deleted, then delete it's a file or
     * call recursive folder deletion if it's a directory.
     *
     * @param string $sFileName
     * @param string $sFilePath
     */
    protected static function _clear($sFileName, $sFilePath)
    {
        if (!in_array($sFileName, array('.', '..', '.gitkeep', '.htaccess'))) {
            if (is_file($sFilePath)) {
                @unlink($sFilePath);
            } else {
                self::clearTmp($sFilePath);
            }
        }
    }

    /**
     * Get translated string by the translation code.
     *
     * @param string  $sCode
     * @param boolean $blUseModulePrefix If True - adds the module translations prefix, if False - not.
     *
     * @return string
     */
    public function translate($sCode, $blUseModulePrefix = true)
    {
        if ($blUseModulePrefix) {
            $sCode = 'OE_GDPRBASE_' . $sCode;
        }

        return oxRegistry::getLang()->translateString($sCode, oxRegistry::getLang()->getBaseLanguage(), false);
    }

    /**
     * Get CMS snippet content by identified ID.
     *
     * @param string $sIdentifier
     * @param bool   $blNoHtml
     *
     * @return string
     */
    public function getCmsContent($sIdentifier, $blNoHtml = true)
    {
        $sValue = '';

        /** @var oxContent|oxI18n $oContent */
        $oContent = oxNew('oxContent');
        $oContent->loadByIdent(trim((string) $sIdentifier));

        if ($oContent->oxcontents__oxcontent instanceof oxField) {
            $sValue = (string) $oContent->oxcontents__oxcontent->getRawValue();
            $sValue = (empty($blNoHtml) ? $sValue : nl2br(strip_tags($sValue)));
        }

        return $sValue;
    }

    /**
     * Get module setting value.
     *
     * @param string  $sModuleSettingName Module setting parameter name (key).
     * @param boolean $blUseModulePrefix  If True - adds the module settings prefix, if False - not.
     *
     * @return mixed
     */
    public function getSetting($sModuleSettingName, $blUseModulePrefix = true)
    {
        if ($blUseModulePrefix) {
            $sModuleSettingName = 'oeGdprBase' . (string) $sModuleSettingName;
        }

        return oxRegistry::getConfig()->getConfigParam((string) $sModuleSettingName);
    }

    /**
     * Get module path.
     *
     * @return string Full path to the module directory.
     */
    public function getPath()
    {
        return oxRegistry::getConfig()->getModulesDir() . 'oe/gdprbase/';
    }
}
