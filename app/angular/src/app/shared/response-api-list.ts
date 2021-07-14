export interface ResponseApiList<T> {
  hasNext: boolean;
  items: Array<T>;
}
