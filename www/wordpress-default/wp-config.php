<?php
/**
 * The base configurations of the WordPress.
 *
 * This file has the following configurations: MySQL settings, Table Prefix,
 * Secret Keys, WordPress Language, and ABSPATH. You can find more information
 * by visiting {@link http://codex.wordpress.org/Editing_wp-config.php Editing
 * wp-config.php} Codex page. You can get the MySQL settings from your web host.
 *
 * This file is used by the wp-config.php creation script during the
 * installation. You don't have to use the web site, you can just copy this file
 * to "wp-config.php" and fill in the values.
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'wordpress_default');

/** MySQL database username */
define('DB_USER', 'wp');

/** MySQL database password */
define('DB_PASSWORD', 'wp');

/** MySQL hostname */
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         ';YiRd%Ayj[N* +V%F0Kza4V~UG0}!^n/X1s4yfA|B{~?|WXQ?ZW3}`,g&/*US|T1');
define('SECURE_AUTH_KEY',  'Vc?f_kk+rj`]e_y4.}V 29pEM@XOG&YTqDv<eV[*9IC8:**g_ +RfESI}%$+2|4<');
define('LOGGED_IN_KEY',    'F&vX mE[hjH.%~Hr8w=>3<pO ~G<b(c9`)U+SbgO|ap}f:o:Q& W!+$&L)-t+gRC');
define('NONCE_KEY',        '~olrMz|4>;;v$%@2}}z]<1.0w(oW@*Iu6umV+NARd=s+&&%lNlO}U[;>]My5>F C');
define('AUTH_SALT',        '1YK>/qQyv:@G+%t.c5m+%@QMp8l7eB5!rxip@pZ#5Q5?3,B04)Q<7|Qi@y|Nc{qr');
define('SECURE_AUTH_SALT', 'ryx(J1T/a9f^ez-7~@z%C^wQ(]-c`#|cw8{[2~jwmH,:>/$LHeb^:#[.m<q+qxot');
define('LOGGED_IN_SALT',   ' #o]^Y40@1cvo>@gvs%Wa6/X::dB$l(LSJ<id?ky1{p]@Ae~=xP}MO Chy^)lZZ_');
define('NONCE_SALT',       '$7HVJ~]}F)l2k8zFMG!.aSiFuY Y h-sG8|7SoPe>0L3s6rz=#1b>[[rJhFtrAH!');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each a unique
 * prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * WordPress Localized Language, defaults to English.
 *
 * Change this to localize WordPress. A corresponding MO file for the chosen
 * language must be installed to wp-content/languages. For example, install
 * de_DE.mo to wp-content/languages and set WPLANG to 'de_DE' to enable German
 * language support.
 */
define('WPLANG', '');

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
