import { formatDate } from "@angular/common";

export class TaskAppUtils {
  static convertDateToString(date: string | null | undefined, format: string = 'dd/MM/yyyy',
    alwaysShowYear: boolean = true
  ): string {      
    if (!date) return '';
    
    const d = new Date(date);

    if (isNaN(d.getTime())) return '';

    if (!alwaysShowYear) {
      const currentYear = new Date().getFullYear();
      const year = d.getFullYear();

      if (currentYear === year) {
        format = format
          .replace(/(^|[-/]\s*|\s*[-/])y{2,4}($|[-/]|)/g, '')
          .replace(/\s{2,}/g, ' ')
          .replace(/\s*[-/]\s*$/g, '')
          .replace(/^\s*[-/]\s*/g, '');
      }
    }

    return formatDate(d, format, 'pt-BR');
  }
}