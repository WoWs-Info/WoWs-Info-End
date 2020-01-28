import { Theme, DarkTheme, DefaultTheme, Colors, configureFonts } from 'react-native-paper';
import { DATA_KEY } from '../Cacheable';
import AsyncStorage from '@react-native-community/async-storage';
import { Preference } from './';

/**
 * Custom theme (a wrapper around Theme from react native paper)
 * - Dark or light mode
 * - Primary colour
 */
class UserTheme implements Preference {
  private dark?: boolean;
  private primary?: string;

  // Maybe change the fonts?
  private fontConfig = {
    default: {
      regular: {
        fontFamily: 'Helvetica Neue',
        fontWeight: '400' as '400',
      },
      medium: {
        fontFamily: 'Helvetica Neue',
        fontWeight: '500' as '500',
      },
      light: {
        fontFamily: 'Helvetica Neue',
        fontWeight: '300' as '300',
      },
      thin: {
        fontFamily: 'Helvetica Neue',
        fontWeight: '100' as '100',
      },
    },
  };

  constructor();
  constructor(dark: boolean, primary: string);
  constructor(dark?: boolean, primary?: string) {
    // Normal mode
    this.dark = dark;
    this.primary = primary;
  }

  save() {
    if (this.dark != null) {
      AsyncStorage.setItem(DATA_KEY.user_theme, JSON.stringify(this)).catch(err => {
        console.error(err);
      });
    } else {
      console.error('UserTheme is not initialised');
    }
  }

  async load(): Promise<void> {
    let jsonString = await AsyncStorage.getItem(DATA_KEY.user_theme);
    this.fromJSON(jsonString);
  }

  fromJSON(jsonString: string | null) {
    if (jsonString) {
      let json = JSON.parse(jsonString);
      this.dark = json.dark;
      this.primary = json.primary;
    } else {
      this.default();
    }
  }

  default() {
    this.dark = false;
    this.primary = Colors.blue500;

    this.save();
  }

  /**
   * If this theme is a dark theme
   */
  isDarkTheme(): boolean {
    return this.dark!;
  }

  /**
   * If this theme is light
   * - Light -> dark text
   * - Not light -> white text
   */
  isLight(): boolean {
    // Dark mode will always be dark
    if (this.dark) return false;

    const c = this.primary!.substring(1);
    const rgb = parseInt(c, 16);
    const r = (rgb >> 16) & 0xff;
    const g = (rgb >> 8) & 0xff;
    const b = (rgb >> 0) & 0xff;

    // luma is from 0 to 255, 0 is the darkest and 255 is the brightnes
    const luma = 0.2126 * r + 0.7152 * g + 0.0722 * b;
    return luma > 128 ? true : false;
  }

  /**
   * Get the primary colour
   */
  getPrimary(): string {
    return this.primary!;
  }

  /**
   * Get your custom theme based on your selection
   * @returns a theme object
   */
  getTheme(): Theme {
    const baseTheme = this.dark ? DarkTheme : DefaultTheme;

    // There might be some changes in the future
    return {
      ...baseTheme,
      colors: {
        ...baseTheme.colors,
        primary: this.primary!,
      },
      // fonts: configureFonts(this.fontConfig)
    };
  }
}

export { UserTheme };
