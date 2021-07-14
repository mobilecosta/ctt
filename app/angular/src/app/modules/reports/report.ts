export interface Report {
  id: number;
  sample: number;
  created: Date;
  emmited: Date;
  nextCollect: Date;
  reportType: null;
  diagnostic: string;
  recommendation: string;
  sign: string;
  note?: string;
  criticality: Criticality;
}

export interface Criticality{
  label: string;
  level: string;
  recno: number;
}

export interface ReportList {
    hasNext: boolean;
    items: Report[];
}
