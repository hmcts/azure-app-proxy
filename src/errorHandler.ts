export async function errorHandler(when: string, result: Response) {
  if (!result.ok) {
    console.log();

    let body = null;
    try {
      body = await result.json();
    } catch (err) {}
    throw new Error(
      `Error ${when}, status: ${result.status}, statusText: ${
        result.statusText
      }, body: ${JSON.stringify(body)}`,
    );
  }
}
