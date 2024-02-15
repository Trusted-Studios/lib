<script lang="ts">
    import { Button, Card, Popover } from "flowbite-svelte";

    const Items = [
        {
            title: "Item 1",
            description: "Description 1",
            image: "https://via.placeholder.com/150",
            id: "item1",
        },
        {
            title: "Item 2",
            description: "Description 2",
            image: "https://via.placeholder.com/150",
            id: "item2",
        },
        {
            title: "Item 3",
            description: "Description 3",
            image: "https://via.placeholder.com/150",
            id: "item3",
        },
        {
            title: "Item 4",
            description: "Description 4",
            image: "https://via.placeholder.com/150",
            id: "item4",
        },
    ];
</script>

<center class="mt-[4rem]">
    <Card class="min-w-[64rem] max-h-[48rem] overflow-auto">
        <div class="grid grid-cols-4 gap-4">
            {#each Items as Item}
                <div>
                    <Card img={Item.image} id="{Item.id}" class="hover:cursor-pointer">
                        <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">{Item.title}</h5>
                        <p class="mb-3 font-normal text-gray-700 dark:text-gray-400 leading-tight">{Item.description}</p>
                    </Card>
                    <Popover class="w-64 text-sm font-light" title="Popover title" triggeredBy="#{Item.id}">
                        And here's some amazing content. It's very engaging. Right?
                        <Button class="max-w-[12rem] mt-4">Auswählen</Button>
                    </Popover>
                </div>
            {/each}
            </div>
    </Card>
</center>
