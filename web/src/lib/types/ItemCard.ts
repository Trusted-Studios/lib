interface Item {
    id: string,
    title: string,
    list?: string[],
    description?: string,
    image?: string | null,
}

export type ItemCards = Array<Item>;