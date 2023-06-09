export async function errorHandler(when: string, result: Response) {
  if (!result.ok) {
    console.log(`Error ${when}`, result.status);
    console.log(result.statusText);
    console.log(await result.json());
    // @ts-ignore
    process.exit(1);
  }
}
