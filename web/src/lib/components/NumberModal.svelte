<script lang="ts">
    import { Button, Label, Modal, Range } from "flowbite-svelte";
    import { useNuiEvent } from "../utils/NuiEvents";
    import { fetchNui } from "../utils/FetchNui";

    let wasOpen: boolean = false;
    let open: boolean = false;
    let description: string = "Choose a number.";
    let confirm: string = "Confirm";
    let rangeLabel: string = "Amount:";
    let range: {min: number, max: number} = {
        min: 0,
        max: 0
    };
    let other: any

    useNuiEvent('open:numberModal', function(data: any) {
        open = true;
        wasOpen = true;
        description = data?.description || description,
        confirm = data?.confirm || confirm,
        rangeLabel = data?.rangeLabel || rangeLabel,
        range = data?.range || range,
        other = data?.other
    });

    let value: number = 0;

    function confirmNumber() {
        fetchNui('confirm:numberModal', {
            count: value,
            other: other
        })
        open = false
        wasOpen = false
    }

    $: {
        if (wasOpen && open == false) {
            console.log('close')
            fetchNui('close', {
                component: "numberModal"
            })
        }
    }
</script>

<Modal bind:open size="xs">
    <p class="text-base leading-relaxed text-gray-500 dark:text-gray-400">{description}</p>
    <Label>{rangeLabel}</Label>
    <Range id="range-minmax" min="{range.min}" max="{range.max}" bind:value={value} />
    <p>Value: {value}</p>
    <svelte:fragment slot="footer">
        <Button class="me-2" on:click={() => confirmNumber()}>{confirm}</Button>
    </svelte:fragment>
</Modal>